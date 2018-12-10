//
//  AFOMediaYUV.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/10.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaYUV.h"

@implementation AFOMediaYUV
#pragma mark ------
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
- (void)dealloc{
    NSLog(@"AFOMediaYUV");
}
@end
