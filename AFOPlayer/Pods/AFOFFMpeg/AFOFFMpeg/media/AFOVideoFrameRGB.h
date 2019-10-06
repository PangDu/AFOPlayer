//
//  AFOVideoFrameRGB.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOVideoFrame.h"

@interface AFOVideoFrameRGB : AFOVideoFrame
@property (nonatomic, assign, readonly)    NSInteger       linesize;
@property (nonatomic, strong, readonly)    NSData         *RGB;
@end
