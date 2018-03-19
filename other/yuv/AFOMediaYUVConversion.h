//
//  AFOMediaYUVConversion.h
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/2.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <libavcodec/avcodec.h>
#import <libavformat/avformat.h>
#import <libswscale/swscale.h>
#import <libavutil/imgutils.h>
@interface AFOMediaYUVConversion : NSObject
- (void)avFrameYUVToCharAVFrame:(AVFrame *)avFrame
                        context:(AVCodecContext *)avCodecContext
                          block:(void(^)(UIImage *image, unsigned char *buffer))block;
@end
