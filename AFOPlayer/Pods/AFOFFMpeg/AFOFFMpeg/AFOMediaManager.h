//
//  AFOMediaManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOFFMpegHeader.h"
@class AFOVideoFrame;
@interface AFOMediaManager : NSObject
- (void)mediaVideoStream:(AVFrame *)frame
            codecContext:(AVCodecContext *)codecContext
                   block:(void (^)(AFOVideoFrame *videoFrame))block;
@end
