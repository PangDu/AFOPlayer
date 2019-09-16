//
//  AFOMediaManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaManager.h"
#import "AFOFFMpegHeader.h"
#import "AFOMediaFrameImport.h"

@interface  AFOMediaManager ()
@end
@implementation AFOMediaManager
- (void)mediaVideoStream:(AVFrame *)frame
            codecContext:(AVCodecContext *)codecContext
                   block:(void (^)(AFOVideoFrame *videoFrame))block{
    AFOVideoFrame *video = [AFOVideoFrame videoFrame:frame codecContext:codecContext type:AFOVideoFrameFormatYUV];
    block(video);
}
@end
