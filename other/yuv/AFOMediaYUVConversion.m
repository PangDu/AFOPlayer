//
//  AFOMediaYUVConversion.m
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/2.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOMediaYUVConversion.h"
#import "AFOMediaMacroDefinition.h"
#import <string.h>
//#import "libyuv.h"
@implementation AFOMediaYUVConversion
#pragma mark ------
- (void)avFrameYUVToCharAVFrame:(AVFrame *)avFrame
                        context:(AVCodecContext *)avCodecContext
                   block:(void(^)(UIImage *image, unsigned char *buffer))block{
   unsigned char *buf =  (unsigned char *)malloc(avCodecContext -> height * avCodecContext -> width * 3/2);
    memset(buf, 0, avCodecContext->height * avCodecContext->width * 3/2);
    int height = avCodecContext->height;
    int width = avCodecContext->width;
//    printf("decode video ok\n");
    int a = 0;
    ///------ Y
    for (int i = 0; i < height; i++){
        memcpy(buf + a, avFrame->data[0] + i * avFrame->linesize[0], width);
        a += width;
    }
    ///------ U
    for (int i = 0; i< height / 2; i++){
        memcpy(buf + a, avFrame->data[1] + i * avFrame->linesize[1], width / 2);
        a += width / 2;
    }
    ///------ V
    for (int i = 0; i< height / 2; i++){
        memcpy(buf + a, avFrame->data[2] + i * avFrame->linesize[2], width / 2);
        a += width / 2;
    }
//    [AFOMediaYUVConversion makeUIImage:buf width:width height:height scale:1.0 block:^(UIImage *image) {
//        block(image,buf);
//    }];
//   UIImage *image = [AFOMediaYUVConversion makeUIImage:(buf) width:width height:height scale:1.0];
//    block (image, buf);
    [AFOMediaYUVConversion YUVtoImageWidth:width height:height buffer:buf block:^(UIImage *image) {
        block(image,buf);
    }];
}
#pragma mark ------ YUV(NV12)-->CIImage--->UIImage Conversion
+ (void)YUVtoImageWidth:(int)width height:(int)height buffer:(unsigned char *)buffer block:(void (^)(UIImage *image))block{
    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          width,
                                          height,
                                          kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    
    ///------ Here ch0 is Y-Plane of YUV(NV12) data.
    unsigned char *ch0 = buffer;
    unsigned char *ch1 = buffer + (width * height);
    memcpy(yDestPlane, ch0, width * height);
    unsigned char *uvDestPlane = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    
    ///------ Here ch1 is UV-Plane of YUV(NV12) data.
    memcpy(uvDestPlane, ch1, width * height/2);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    
    ///------ CIImage Conversion
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:coreImage
                                                       fromRect:CGRectMake(0, 0, width, height)];
    
    ///------ UIImage Conversion
    UIImage *nnnimage = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationUp];
    block(nnnimage);
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(videoImage);
}
#pragma mark ------ libYUV To Image
+ (void)makeUIImage:(unsigned char *)inBaseAddress
                   width:(size_t)inWidth
                  height:(size_t)inHeight
                   scale:(int)scale block:(void (^)(UIImage *image))block{
//    if (scale < 1) {
//        scale = 3;
//    }
//    ///------
//    unsigned char* y0  = inBaseAddress;
//    unsigned char* uv0 = inBaseAddress + inWidth * inHeight * sizeof(unsigned char);
//    size_t outWidth  = inWidth  / scale;
//    size_t outHeight = inHeight / scale;
//    outWidth  = (outWidth  >> 2) << 2;
//    outHeight = (outHeight >> 2) << 2;
//    align_buffer_64(sdata, outWidth * outHeight * 1.5 * sizeof(unsigned char));
//    unsigned char* y1  = sdata;
//    unsigned char* uv1 = sdata + outWidth * outHeight;
//    memset(uv1, 128, 1 * outWidth * outHeight);
//    ScalePlane_16((uint16*)uv0,     (int)inWidth   / 2,
//                  (int)inWidth  / 2, (int)inHeight  / 2,
//                  (uint16*)uv1,     (int)outWidth  / 2,
//                  (int)outWidth / 2, (int)outHeight / 2,
//                  kFilterNone);
//    ScalePlane(y0,          (int)inWidth,
//               (int)inWidth, (int)inHeight,
//               y1,           (int)outWidth,
//               (int)outWidth, (int)outHeight,
//               kFilterNone);
//    unsigned char* argb  = (unsigned char*)malloc(outWidth * outHeight * 4 * sizeof(unsigned char));
//
//    NV12ToARGB(y1, (int)outWidth, uv1, (int)outWidth, argb, (int)outWidth * 4, (int)outWidth, (int)outHeight);
//    
//    free_aligned_buffer_64(sdata);
//    ///------ UIImage
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(argb, outWidth, outHeight, 8, outHeight * 4, colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    ///------ free
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    CGImageRelease(quartzImage);
//    free(argb);
//    argb = NULL;
//    ///------ block
//    block(image);
}
@end
