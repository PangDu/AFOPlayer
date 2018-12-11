//
//  AFOMediaYUV.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/10.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaYUV.h"
@interface AFOMediaYUV ()
@property (nonatomic, assign) CVPixelBufferPoolRef pixelBufferPool;
@property (nonatomic, assign) CVPixelBufferRef     pixelBuffer;
@end

@implementation AFOMediaYUV
#pragma mark ------ 420P -> RGBA -> CGImageRef -> image
+ (UIImage *)makeYUVToRGB:(AVFrame *)avFrame
                   width:(int)inWidth
                  height:(int)inHeight
                   scale:(int)scale{
    uint8 *argb  = (uint8 *) malloc(inWidth * inHeight * 4 *3 * sizeof(uint8));
    I420ToBGRA(avFrame ->data[0],
               avFrame ->linesize[0],
               avFrame ->data[1],
               avFrame ->linesize[1],
               avFrame ->data[2],
               avFrame ->linesize[2],
               argb,
               inWidth * 4,
               inWidth,
               inHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(argb, inWidth, inHeight, 8, inWidth * 4 , colorSpace,kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:scale orientation:UIImageOrientationUp];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(quartzImage);
    free(argb);
    argb = NULL;
    return image;
}
#pragma mark ------ 420P -> nv12 -> CIImage -> image
- (void)dispatchAVFrame:(AVFrame*) frame
                  block:(void (^)(UIImage *image))block{
    
    if(!frame || !frame->data[0]){
        return;
    }
    @autoreleasepool {
        AVFrame *avFrameYUV = av_frame_alloc();
        int numBytes = av_image_get_buffer_size(AV_PIX_FMT_NV12,frame->width,frame->height, 1);
        uint8_t *avFrameYUVBuffer = (uint8_t *)av_malloc(numBytes * sizeof(uint8_t));
        av_image_fill_arrays(avFrameYUV -> data, avFrameYUV -> linesize, avFrameYUVBuffer, AV_PIX_FMT_NV12, frame->width, frame->height, 1);
        I420ToNV12(frame->data[0],
                   frame->linesize[0],
                   frame->data[1],
                   frame->linesize[1],
                   frame->data[2],
                   frame->linesize[2],
                   avFrameYUV->data[0],
                   frame->linesize[0],
                   avFrameYUV->data[1],
                   avFrameYUV->linesize[1],
                   frame->width,
                   frame->height
                   );
        NSMutableDictionary *attributes = [self dictionary:frame->width height:frame->height lineSize:frame->linesize[0]];
        if (!_pixelBufferPool) {
            CVPixelBufferPoolCreate(kCFAllocatorDefault,
                                    NULL,
                                    (__bridge CFDictionaryRef) attributes,
                                    &_pixelBufferPool);
        }
        ///---
        if (!_pixelBuffer) {
            CVPixelBufferPoolCreatePixelBuffer(NULL,_pixelBufferPool, &_pixelBuffer);
            CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                                  frame->width,
                                                  frame->height,
                                                  kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                                  (__bridge CFDictionaryRef)(attributes),
                                                  &_pixelBuffer);
            if (result != kCVReturnSuccess) {
                NSLog(@"Unable to create cvpixelbuffer %d", result);
                return;
            }
        }
        ///---
        CVPixelBufferLockBaseAddress(_pixelBuffer, 0);
        size_t bytePerRowY = CVPixelBufferGetBytesPerRowOfPlane(_pixelBuffer, 0);
        size_t bytesPerRowUV = CVPixelBufferGetBytesPerRowOfPlane(_pixelBuffer, 1);
        void* base = CVPixelBufferGetBaseAddressOfPlane(_pixelBuffer, 0);
        memcpy(base, avFrameYUV->data[0], bytePerRowY * frame->height);
        base = CVPixelBufferGetBaseAddressOfPlane(_pixelBuffer, 1);
        memcpy(base, avFrameYUV->data[1], bytesPerRowUV * frame->height/2);
        CVPixelBufferUnlockBaseAddress(_pixelBuffer, 0);
        ///---
        CIImage *coreImage = [CIImage imageWithCVPixelBuffer:_pixelBuffer];
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext createCGImage:coreImage
                                                       fromRect:CGRectMake(0, 0, frame ->width, frame -> height)];
        ///------ UIImage Conversion
        UIImage *image = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationUp];
        block(image);
        free(avFrameYUVBuffer);
        av_free(avFrameYUV);
    }
}
- (NSMutableDictionary *)dictionary:(int)width
                             height:(int)height
                           lineSize:(int)lineSize{
    NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithInt:width] forKey: (NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithInt:height] forKey: (NSString*)kCVPixelBufferHeightKey];
    [attributes setObject:@(lineSize) forKey:(NSString*)kCVPixelBufferBytesPerRowAlignmentKey];
    [attributes setObject:[NSDictionary dictionary] forKey:(NSString*)kCVPixelBufferIOSurfacePropertiesKey];
    return attributes;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOMediaYUV");
}
@end
