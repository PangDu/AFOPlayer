//
//  AFOPlayMediaViewModel.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2017/12/28.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOPlayMediaManager.h"
#import "AFOGenerateImages.h"
#import "AFOMediaErrorCodeManager.h"
#import "AFOMediaQueueManager.h"
@interface AFOPlayMediaManager (){
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVFrame             *avFrame;
}
/**输出视频Size*/
@property (nonatomic, assign) CGSize         outSize;
/**视频的长度，秒为单位*/
@property (nonatomic, assign) int64_t        duration;
/**视频的当前秒数*/
@property (nonatomic, assign) int64_t        currentTime;
/**视频的当前秒数*/
@property (nonatomic, assign) int64_t        nowTime;
/**视频的帧率*/
@property (nonatomic, assign) CGFloat         fps;
@property (nonatomic, assign)            NSInteger       videoStream;
@property (nonatomic, assign)            CGFloat         videoTimeBase;
@property (nonatomic, assign)            BOOL            isRelease;
@property (nonatomic, strong) AFOMediaQueueManager      *queueManager;
@property (nonatomic, strong) AFOGenerateImages         *generateImage;
@property (nonatomic, weak) id<AFOPlayMediaManager>      delegate;
@end

@implementation AFOPlayMediaManager

#pragma mark ------ init
- (instancetype)initWithDelegate:(id<AFOPlayMediaManager>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        _isRelease = NO;
        [INTUAutoRemoveObserver addObserver:self selector:@selector(freeResources) name:@"AFOPlayMediaManagerFreeResources" object:nil];
    }
    return self;
}
#pragma mark ------ displayVedio
- (void)displayVedioFormatContext:(AVFormatContext *)formatContext
                     codecContext:(AVCodecContext *)codecContext
                            index:(NSInteger)index
                            block:(displayVedioFrameBlock)block{
    self.videoStream = index;
    avCodecContext = codecContext;
    avFormatContext =formatContext;
    avFrame = av_frame_alloc();
    WeakObject(self);
    ///------
    [self.queueManager addCountdownActionFps:self.fps duration:weakself.duration block:^(NSNumber *isEnd) {
        if ([isEnd boolValue]) {
            block(NULL,
                  NULL,
                  [AFOMediaTimer timeFormatShort:weakself.duration],[AFOMediaTimer currentTime:weakself.nowTime + 1],
                  weakself.duration,
                  weakself.nowTime + 1);
            //
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaStopManager" object:nil];
            [weakself freeResources];
            return ;
        }else{
            if ([weakself avReadFrame:weakself.videoStream]) {
                [weakself decodingFrameToImage:^(UIImage *image, NSError *error) {
                    if (error.code != 0) {
                        block(NULL, NULL, NULL, NULL, 0 , 0);
                    }else{
                        block(error,
                              image,
                              [AFOMediaTimer timeFormatShort:weakself.duration],
                              [AFOMediaTimer currentTime:weakself.nowTime],
                              weakself.duration,
                              weakself.nowTime
                              );
                    }
                }];
            }else{
                block(NULL, NULL, NULL, NULL, 0, 0);
            }
        }
    }];
}
#pragma mark ------ YUV to image
- (void)decodingFrameToImage:(void (^) (UIImage *image, NSError *error))block{
    [self.generateImage decoedImageForYUV:avFrame outSize:self.outSize block:^(UIImage *image, NSError *error) {
        block(image,error);
    }];
}
#pragma mark ------ stepFrame
- (BOOL)avReadFrame:(NSInteger)duration {
    AVPacket  packet;
    while (av_read_frame(avFormatContext, &packet) >= 0) {
        if (packet.stream_index == duration) {
            int ret = avcodec_send_packet(avCodecContext, &packet);
            if (ret == 0) {
                while (!avcodec_receive_frame(avCodecContext, avFrame)) {
                    double frameRate = av_q2d([self avStream] -> avg_frame_rate);
                    frameRate += avFrame->repeat_pict * (frameRate * 0.5);
                    [self.delegate videoTimeStamp:av_frame_get_best_effort_timestamp(avFrame) * av_q2d([self avStream] -> time_base) position:_videoTimeBase frameRate:frameRate];
                    self.nowTime = self.currentTime;
                    av_packet_unref(&packet);
                    return YES;
                }
            }else{
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark ------ 释放资源
- (void)freeResources{
    if (_isRelease) {
        return;
    }
    if (avFrame) {
        av_frame_free(&(avFrame));
    }
    //---
    if (avFormatContext) {
        avformat_close_input(&avFormatContext);
        avFormatContext = NULL;
    }
    //---
    if (avCodecContext) {
        avcodec_close(avCodecContext);
        avcodec_free_context(&avCodecContext);
        avCodecContext = NULL;
    }
    _isRelease = YES;
}
#pragma mark ------------ property
- (AVStream *)avStream{
    AVStream *stream = avFormatContext -> streams[self.videoStream];
    return stream;
}
- (int64_t)duration{
    int64_t totalTime = [self avStream] -> duration * av_q2d([self avStream] -> time_base);
    if (totalTime > 0) {
          return [self avStream] -> duration * av_q2d([self avStream] -> time_base);
    }
    return  [AFOMediaTimer totalNumberSeconds:avFormatContext->duration];
}
- (int64_t)currentTime{
    AVRational timeBase = avFormatContext->streams[self.videoStream]->time_base;
    return avFrame->pts * (double)timeBase.num / timeBase.den;
}
- (CGFloat)fps{
    if([self avStream] ->avg_frame_rate.den && [self avStream] ->avg_frame_rate.num){
        return av_q2d([self avStream] -> avg_frame_rate);
    }
    return 30;
}
- (CGSize)outSize{
    return CGSizeMake(avFrame ->width, avFrame -> height);
}
- (AFOMediaQueueManager *)queueManager{
    if (!_queueManager) {
        _queueManager = [[AFOMediaQueueManager alloc] init];
    }
    return _queueManager;
}
- (AFOGenerateImages *)generateImage{
    if (!_generateImage) {
        _generateImage = [[AFOGenerateImages alloc] init];
    }
    return _generateImage;
}
#pragma mark ------------ dealloc
- (void)dealloc{
    [self freeResources];
    NSLog(@"AFOPlayMediaManager dealloc");
}
@end
