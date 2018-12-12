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
    AVCodec             *avcodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVFrame             *avFrame;
    AVStream            *avStream;
    AVPacket             packet;
}
/**视频宽*/
@property (nonatomic, assign, readwrite) double         videoWidth;
/**视频高*/
@property (nonatomic, assign, readwrite) double         videoHight;
/**输出视频Size*/
@property (nonatomic, assign, readwrite) CGSize         outSize;
/**视频的长度，秒为单位*/
@property (nonatomic, assign, readwrite) int64_t        duration;
/**视频的当前秒数*/
@property (nonatomic, assign, readwrite) int64_t        currentTime;
/**视频的当前秒数*/
@property (nonatomic, assign, readwrite) int64_t        nowTime;
/**视频的帧率*/
@property (nonatomic, assign, readwrite) CGFloat         fps;
/**视频长度*/
@property (nonatomic, assign)            NSInteger       videoStream;
@property (nonatomic, assign)            CGFloat         videoTimeBase;
/***/
@property (nonatomic, assign)            BOOL            isRelease;
/**queueManager*/
@property (nonatomic, strong) AFOMediaQueueManager      *queueManager;
/**generateImage*/
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
#pragma mark ------ add method
#pragma mark ------ 
- (void)displayVedioCodec:(AVCodec *)codec
            formatContext:(AVFormatContext *)formatContext
             codecContext:(AVCodecContext *)codecContext
                    index:(NSInteger)index
                    block:(displayVedioFrameBlock)block{
    self.videoStream = index;
    avcodec =codec;
    avCodecContext = codecContext;
    avFormatContext =formatContext;
    ///------ 获取视频流编解码上下文指针
    avStream = avFormatContext -> streams[self.videoStream];
    ///------
    self.outSize = CGSizeMake(avCodecContext -> width,avCodecContext -> height);
    ///------ 正常流程，分配视频帧
    avFrame = av_frame_alloc();
    avStreamFPSTimeBase(avStream, 0.04, &_fps, &_videoTimeBase);
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
- (void)decodingFrameToImage:(void (^) (UIImage *image, NSError *error))block{
    [self.generateImage decoedImageForYUV:avFrame outSize:self.outSize block:^(UIImage *image, NSError *error) {
        block(image,error);
    }];
}
#pragma mark ------ stepFrame
- (BOOL)avReadFrame:(NSInteger)duration {
    while (av_read_frame(avFormatContext, &packet) >= 0) {
        if (packet.stream_index == duration) {
            int ret = avcodec_send_packet(avCodecContext, &packet);
            if (ret == 0) {
                while (!avcodec_receive_frame(avCodecContext, avFrame)) {
                    double frameRate = av_q2d(avStream -> avg_frame_rate);
                    frameRate += avFrame->repeat_pict * (frameRate * 0.5);
                    [self.delegate videoTimeStamp:av_frame_get_best_effort_timestamp(avFrame) * av_q2d(avStream -> time_base) position:_videoTimeBase frameRate:frameRate];
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
    NSLog(@"释放资源");
    ///------ avFrame
    av_frame_free(&(avFrame));
    ///------ avStream
    av_free(avStream);
    ///------ packet
    av_packet_unref(&packet);
    _isRelease = YES;
}
#pragma mark ------------ property
#pragma mark ------ duration
- (int64_t)duration{
    AVStream *stream = avFormatContext -> streams[_videoStream];
    return stream -> duration * av_q2d(stream -> time_base);
}
#pragma mark ------ currentTime
- (int64_t)currentTime{
    AVRational timeBase = avFormatContext->streams[_videoStream]->time_base;
    return packet.pts * (double)timeBase.num / timeBase.den;
}
#pragma mark ------ fps
- (CGFloat)fps{
    if(avStream ->avg_frame_rate.den && avStream ->avg_frame_rate.num){
       return av_q2d(avStream -> avg_frame_rate);
    }
    return 30;
}
#pragma mark ------ queueManager
- (AFOMediaQueueManager *)queueManager{
    if (!_queueManager) {
        _queueManager = [[AFOMediaQueueManager alloc] init];
    }
    return _queueManager;
}
#pragma mark ------ generateImage
- (AFOGenerateImages *)generateImage{
    if (!_generateImage) {
        _generateImage = [[AFOGenerateImages alloc] init];
    }
    return _generateImage;
}
#pragma mark ------------ dealloc
- (void)dealloc{
    [self freeResources];
    NSLog(@"dealloc AFOPlayMediaManager");
}
#pragma mark ------ C
static void avStreamFPSTimeBase(AVStream *st, CGFloat defaultTimeBase, CGFloat *pFPS, CGFloat *pTimeBase){
    CGFloat fps, timebase;
    
    if (st->time_base.den && st->time_base.num)
        timebase = av_q2d(st->time_base);
    else if(st->codecpar->sample_aspect_ratio.den && st->codecpar->sample_aspect_ratio.num)
        timebase = av_q2d(st->codecpar->sample_aspect_ratio);
    else
        timebase = defaultTimeBase;
    
    if (st->avg_frame_rate.den && st->avg_frame_rate.num)
        fps = av_q2d(st->avg_frame_rate);
    else if (st->r_frame_rate.den && st->r_frame_rate.num)
        fps = av_q2d(st->r_frame_rate);
    else
        fps = 1.0 / timebase;
    
    if (pFPS)
        *pFPS = fps;
    if (pTimeBase)
        *pTimeBase = timebase;
}
@end
