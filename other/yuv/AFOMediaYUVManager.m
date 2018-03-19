//
//  AFOMediaYUVManager.m
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/3.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOMediaYUVManager.h"
#import "AFOMediaYUVConversion.h"

@interface AFOMediaYUVManager ()
@property (nonatomic, strong) AFOMediaYUVConversion *yuvConversion;
@end
@implementation AFOMediaYUVManager
- (void)avFrameYUVToCharBuffer:(AVFrame *)avFrame
                      context:(AVCodecContext *)avCodecContext
                         block:(void(^)(UIImage *image, unsigned char *buffer))block{
    [self.yuvConversion avFrameYUVToCharAVFrame:avFrame context:avCodecContext block:^(UIImage *image, unsigned char *buffer) {
        block(image, buffer);
    }];
}
#pragma mark ------------ property
- (AFOMediaYUVConversion *)yuvConversion{
    if (!_yuvConversion) {
        _yuvConversion = [[AFOMediaYUVConversion alloc] init];
    }
    return _yuvConversion;
}
@end
