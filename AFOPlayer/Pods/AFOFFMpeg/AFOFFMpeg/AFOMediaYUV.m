//
//  AFOMediaYUV.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/10.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//
#import "AFOMediaYUV.h"
#import "libyuv/include/libyuv.h"
@interface AFOMediaYUV ()
@property (nonatomic, assign) CVPixelBufferPoolRef pixelBufferPool;
@property (nonatomic, assign) CVPixelBufferRef     pixelBuffer;
@end

@implementation AFOMediaYUV
#pragma mark ------ 420P -> RGBA -> CGImageRef -> image
+ (void)makeYUVToRGB:(AVFrame *)avFrame
                   width:(int)inWidth
                  height:(int)inHeight
                   scale:(int)scale
                    block:(void (^)(UIImage *image))block{
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
    block(image);
}
#pragma mark ------ 420P -> nv12 -> CIImage -> image
- (void)dispatchAVFrame:(AVFrame*) frame
                  block:(void (^)(UIImage *image))block{
    if(!frame || !frame->data[0]){
        return;
    }
    ///--- 420P -> nv12
    int numBytes = av_image_get_buffer_size(AV_PIX_FMT_NV12,frame->width,frame->height, 1);
    uint8_t *bufferY = (uint8_t *)malloc(numBytes * sizeof(uint8_t));
    uint8_t *bufferUV = (uint8_t *)malloc(numBytes / 2 * sizeof(uint8_t));
    I420ToNV12(frame->data[0],
                   frame->linesize[0],
                   frame->data[1],
                   frame->linesize[1],
                   frame->data[2],
                   frame->linesize[2],
                   bufferY,
                   frame->linesize[0],
                   bufferUV,
                   frame->linesize[1] + frame->linesize[2],
                   frame->width,
                   frame->height
                   );
    ///---
    NSMutableDictionary *attributes = [AFOMediaYUV dictionary:frame->width height:frame->height lineSize:frame->linesize[0]];
    [self pixelBufferPoolRef:attributes];
    CVPixelBufferRef pBuffer = [self pixelBufferWidth:frame->width height:frame->height dictionary:attributes];
    ///---
    CVPixelBufferLockBaseAddress(pBuffer, 0);
    size_t bytePerRowY = CVPixelBufferGetBytesPerRowOfPlane(pBuffer, 0);
    size_t bytesPerRowUV = CVPixelBufferGetBytesPerRowOfPlane(pBuffer, 1);
    void *base = CVPixelBufferGetBaseAddressOfPlane(pBuffer, 0);
    memcpy(base,bufferY, bytePerRowY * frame->height);
    base = CVPixelBufferGetBaseAddressOfPlane(pBuffer, 1);
    memcpy(base,bufferUV, bytesPerRowUV * frame->height/2);
    CVPixelBufferUnlockBaseAddress(pBuffer, 0);
    ///---
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:coreImage
                                                       fromRect:CGRectMake(0, 0, frame ->width, frame -> height)];
    ///------ UIImage Conversion
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationUp];
    block(image);
    free(bufferY);
    free(bufferUV);
    bufferY = NULL;
    bufferUV = NULL;
    base = NULL;
    CGImageRelease(videoImage);
}
+ (NSMutableDictionary *)dictionary:(int)width
                             height:(int)height
                           lineSize:(int)lineSize{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithInt:width] forKey: (NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithInt:height] forKey: (NSString*)kCVPixelBufferHeightKey];
    [attributes setObject:@(lineSize) forKey:(NSString*)kCVPixelBufferBytesPerRowAlignmentKey];
    [attributes setObject:[NSDictionary dictionary] forKey:(NSString*)kCVPixelBufferIOSurfacePropertiesKey];
    return attributes;
}
- (CVPixelBufferPoolRef)pixelBufferPoolRef:(NSMutableDictionary *)dictionary{
    if (!_pixelBufferPool) {
        CVPixelBufferPoolCreate(kCFAllocatorDefault,
                                NULL,
                                (__bridge CFDictionaryRef)dictionary,
                                &_pixelBufferPool);
    }
    return _pixelBufferPool;
}
- (CVPixelBufferRef)pixelBufferWidth:(int)width
                              height:(int)height
                          dictionary:(NSMutableDictionary *)dictionary{
    if (!_pixelBuffer) {
        CVPixelBufferPoolCreatePixelBuffer(NULL,self.pixelBufferPool, &_pixelBuffer);
        CVPixelBufferCreate(kCFAllocatorDefault,
                                              width,
                                              height,
                                              kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange,
                                              (__bridge CFDictionaryRef)(dictionary),
                                              &_pixelBuffer);
    }
    return _pixelBuffer;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOMediaYUV dealloc");
}
@end
