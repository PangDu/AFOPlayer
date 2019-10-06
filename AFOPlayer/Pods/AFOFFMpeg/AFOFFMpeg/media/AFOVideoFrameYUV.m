//
//  AFOVideoFrameYUV.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOVideoFrameYUV.h"
@interface  AFOVideoFrameYUV ()
@property (nonatomic, strong, readwrite) NSData *luma;
@property (nonatomic, strong, readwrite) NSData *chromaB;
@property (nonatomic, strong, readwrite) NSData *chromaR;
@end
@implementation AFOVideoFrameYUV
#pragma mark ------------
+ (instancetype)videoFrameYUV:(AVFrame *)avFrame
                 codecContext:(AVCodecContext *)codecContext{
    AFOVideoFrameYUV *YUV = [[AFOVideoFrameYUV alloc] init];
    ///------   Y
    YUV.luma = [YUV frameData:avFrame -> data[0]
                     linesize:avFrame -> linesize[0]
                        width:codecContext -> width
                       height:codecContext -> height];
    ///------   U
    YUV.chromaB = [YUV frameData:avFrame -> data[1]
                        linesize:avFrame -> linesize[1]
                           width:codecContext -> width / 2
                          height:codecContext -> height / 2];
    ///------   V
    YUV.chromaR = [YUV frameData:avFrame -> data[2]
                        linesize:avFrame -> linesize[2]
                           width:codecContext -> width / 2
                          height:codecContext -> height / 2];
    return YUV;
}
#pragma mark ------------
- (NSData *)frameData:(UInt8 *)src
             linesize:(NSInteger)linesize
                width:(NSInteger)width
               height:(NSInteger)height{
    width = MIN(linesize, width);
    NSMutableData *data = [NSMutableData dataWithLength: width * height];
    Byte *dst = data.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dst, src, width);
        dst += width;
        src += linesize;
    }
    return data;
}
@end
