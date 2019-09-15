//
//  AFOVideoFrameYUV.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOVideoFrame.h"

@interface AFOVideoFrameYUV : AFOVideoFrame
@property (nonatomic, strong, readonly) NSData *luma;
@property (nonatomic, strong, readonly) NSData *chromaB;
@property (nonatomic, strong, readonly) NSData *chromaR;
+ (instancetype)videoFrameYUV:(AVFrame *)avFrame
                 codecContext:(AVCodecContext *)codecContext;
@end
