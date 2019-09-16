//
//  AFOGenerateImages.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/30.
//  Copyright © 2017年 AFO. All rights reserved.
//
#import "AFOGenerateImages.h"
#import "AFOFFMpegHeader.h"
#import "AFOMediaErrorCodeManager.h"
#import "AFOMediaYUV.h"
@interface AFOGenerateImages ()
@property (nonnull, nonatomic, strong) dispatch_queue_t  patchQueue;
@end
@implementation AFOGenerateImages
#pragma mark ------ 图像数据格式的转换以及图片的缩放 方法一
- (void)decoedImageForYUV:(struct AVFrame *)avFrame
                  outSize:(CGSize)outSize
                    block:(generateImageBlock)block{
    [AFOMediaYUV makeYUVToRGB:avFrame width:outSize.width height:outSize.height scale:1.0 block:^(UIImage * _Nonnull image) {
        block(image, [AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone]);
    }];
}
#pragma mark ------ 图像数据格式的转换以及图片的缩放 方法二
//[self.generateImage decodingImageWithAVFrame:avFrame codecContext:avCodecContext outSize:self.outSize srcFormat: AV_PIX_FMT_YUV420P dstFormat:AV_PIX_FMT_RGB24 pixelFormat:AV_PIX_FMT_RGB24 bitsPerComponent:8 bitsPerPixel:24 block:^(UIImage *image, NSError *error) {
//    block(image,error);
//}];
- (void)decodingImageWithAVFrame:(struct AVFrame *)avFrame
                    codecContext:(AVCodecContext *)avCodecContext
                         outSize:(CGSize)outSize
                       srcFormat:(enum AVPixelFormat)srcFormat
                       dstFormat:(enum AVPixelFormat)dstFormat
                     pixelFormat:(enum AVPixelFormat)format
                bitsPerComponent:(size_t)component
                    bitsPerPixel:(size_t)pixel
                            block:(generateImageBlock)block{
    WeakObject(self);
    ///------ SwsContext
    __block struct SwsContext *swsContenxt;
    __block NSError *swsError;
    dispatch_async(weakself.patchQueue, ^{
        StrongObject(self)
        [self swsContextWithAVFrame:avFrame codecContext:avCodecContext outSize:outSize srcFormat:srcFormat dstFormat:dstFormat block:^(struct SwsContext *context, NSError *error) {
            swsContenxt = context;
            swsError = error;
            if (swsError.code != 0) {
                block(NULL,swsError);
                return;
            }
        }];
    });
    ///------ avFrame
    __block struct AVFrame *avframeYUN;
    __block uint8_t  *YUVBuffer;
    dispatch_async(weakself.patchQueue, ^{
        StrongObject(self);
        [self frameWithContext:swsContenxt frame:avFrame size:outSize pixelFormat:format block:^(struct AVFrame *frame,
                                                                                                 uint8_t *buffer) {
            avframeYUN = frame;
            YUVBuffer = buffer;
        }];
    });
    dispatch_barrier_async(weakself.patchQueue, ^(){
    });
    ///------ image
    dispatch_async(weakself.patchQueue, ^{
        StrongObject(self);
        [self imagesConversionSource:avframeYUN outSize:outSize bitsPerComponent:component bitsPerPixel:pixel block:^(UIImage *image, NSError *error) {
            block(image,error);
        }];
        ///------
        av_free(avframeYUN);
        av_free(YUVBuffer);
        sws_freeContext(swsContenxt);
    });
}
#pragma mark ------ 图像数据格式的转换
- (void)swsContextWithAVFrame:(struct AVFrame *)avFrame
                 codecContext:(AVCodecContext *)avCodecContext
                      outSize:(CGSize)outSize
                    srcFormat:(enum AVPixelFormat)srcFormat
                    dstFormat:(enum AVPixelFormat)dstFormat
                        block:(generateSwsContextBlock)block{
    if (!avFrame->data[0]){
        block (NULL, [AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeDecoderImageFailure]);
    }else {
        struct SwsContext *context = sws_getContext(avCodecContext -> width,
                                                    avCodecContext -> height, srcFormat,
                                                    outSize.width,
                                                    outSize.height,
                                                    dstFormat,
                                                    SWS_FAST_BILINEAR,
                                                    NULL,
                                                    NULL,
                                                    NULL);
        if (!context) {
            block(NULL, [AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeImageorFormatConversionFailure]);
        }else{
            block(context, [AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone]);
        }
    }
}
#pragma mark ------------ 图片缩放
- (void)frameWithContext:(struct SwsContext *)context
                               frame:(struct AVFrame *)avFrame
                                size:(CGSize)size
                         pixelFormat:(enum AVPixelFormat)format
                               block:(avframeWithContextBlock)block{
    AVFrame *avFrameYUV = av_frame_alloc();
    int numBytes = av_image_get_buffer_size(format,size.width,size.height, 1);
    uint8_t *avFrameYUVBuffer = (uint8_t *)av_malloc(numBytes * sizeof(uint8_t));
    av_image_fill_arrays(avFrameYUV -> data, avFrameYUV -> linesize, avFrameYUVBuffer, format, size.width, size.height, 1);
    sws_scale(context,
              (const uint8_t* const*)avFrame -> data,
              avFrame -> linesize,
              0,
              avFrame -> height,
              avFrameYUV -> data,
              avFrameYUV -> linesize);
    block(avFrameYUV, avFrameYUVBuffer);
}
#pragma mark ------------ 转化为UIImage
- (void)imagesConversionSource:(struct AVFrame *)avFrame
                       outSize:(CGSize)outSize
              bitsPerComponent:(size_t)component
                  bitsPerPixel:(size_t)pixel
                         block:(generateImageBlock)block{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreate(kCFAllocatorDefault,
                                          avFrame -> data[0],
                                          avFrame-> linesize[0] * outSize.height);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(outSize.width,
                                               outSize.height,
                                               component,
                                               pixel,
                                               avFrame -> linesize[0],
                                               colorSpace,
                                               bitmapInfo,
                                               provider,
                                               NULL,
                                               NO,
                                               kCGRenderingIntentDefault);
    ///------ UIImage
   UIImage *vedioImage = [[UIImage alloc] initWithCGImage:cgImage scale:1.0 orientation:UIImageOrientationUp];
    ///------ block
    block(vedioImage, [AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone]);
    ///------ Release
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provider);
    CFRelease(data);
    CFRelease(cgImage);
}
#pragma mark ------------ property
#pragma mark ------ patchQueue
- (dispatch_queue_t)patchQueue{
    if (!_patchQueue) {
        _patchQueue = dispatch_queue_create("com.AFOMediaManager.queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return _patchQueue;
}
- (void)dealloc{
    NSLog(@"dealloc AFOGenerateImages");
}
@end

