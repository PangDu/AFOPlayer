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
#import "AFOMediaConditional.h"
@interface AFOPlayMediaManager (){
    AVCodec             *avcodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVFrame             *avFrame;
    AVStream            *avStream;
    AVPacket            packet;
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
@property (nonatomic, assign, readwrite) float           fps;

/**视频长度*/
@property (nonatomic, assign)            NSInteger       videoStream;

@property (nonatomic, assign)            BOOL            isRelease;
/**queueManager*/
@property (nonatomic, strong) AFOMediaQueueManager      *queueManager;

/**generateImage*/
@property (nonatomic, strong) AFOGenerateImages         *generateImage;
@end

@implementation AFOPlayMediaManager
- (instancetype)init{
    if (self = [super init]) {
        _isRelease = NO;
        [INTUAutoRemoveObserver addObserver:self selector:@selector(freeResources) name:@"AFOPlayMediaManagerFreeResources" object:nil];
    }
    return self;
}
#pragma mark ------------ initialize
+ (void)initialize{
    if (self == [AFOPlayMediaManager class]) {

    }
}
#pragma mark ------ 设置
- (void)videoPathFor:(NSString *)strPath block:(void (^)(NSError *error)) block{
    ///------ 注册解码器
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    ///------
    WeakObject(self);
    NSError *error ;
    [AFOMediaConditional mediaSesourcesConditionalPath:strPath block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex, CGSize videoSize) {
        error = error;
        if (error.code == 0) {
            weakself.videoStream = videoIndex;
            weakself.outSize = videoSize;
        }
    }];
    ///------
    if (error.code != 0) {
        block(error);
        return;
    }
    ///------
    avformat_open_input(&avFormatContext, [strPath UTF8String], NULL, NULL);
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avcodec = avcodec_find_decoder(avCodecContext -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContext, avcodec, NULL);
    ///------ 获取视频流编解码上下文指针
    avStream = avFormatContext -> streams[self.videoStream];
    ///------ 正常流程，分配视频帧
    avFrame = av_frame_alloc();
    ///------
    block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone]);
}
#pragma mark ------ 播放视频
- (void)displayVedioFrameForPath:(NSString *)strPath
                            block:(displayVedioFrameBlock)block{
    WeakObject(self);
    ///------
    [self videoPathFor:strPath block:^(NSError *error) {
        if (error.code == 0) {
            ///------
            [weakself.queueManager addCountdownActionFps:weakself.fps duration:weakself.duration block:^(NSNumber *isEnd) {
                if ([isEnd boolValue]) {
                    block(error,
                          NULL,
                          [AFOMediaTimer timeFormatShort:weakself.duration],[AFOMediaTimer currentTime:weakself.nowTime + 1],
                          weakself.duration,
                          weakself.nowTime + 1);
                    [weakself freeResources];
                    return ;
                }else{
                    ///------
                    if ([weakself avReadFrame:weakself.videoStream]) {
                        [weakself decodingFrameToImage:^(UIImage *image, NSError *error) {
                            if (error.code != 0) {
                                block(error, NULL, NULL, NULL, 0 , 0);
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
                      block(error, NULL, NULL, NULL, 0, 0);
                    }
                }
            }];
        }else{
            block(error, NULL, NULL, NULL, 0, 0);
        }
    }];
}
- (void)decodingFrameToImage:(void (^) (UIImage *image, NSError *error))block{
    [self.generateImage decodingImageWithAVFrame:avFrame codecContext:avCodecContext outSize:self.outSize srcFormat:AV_PIX_FMT_YUV420P dstFormat:AV_PIX_FMT_RGB24 pixelFormat:AV_PIX_FMT_RGB24 bitsPerComponent:8 bitsPerPixel:24 block:^(UIImage *image, NSError *error) {
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
    ///------   avFrame
    av_free(avFrame);
    ///------   avStream
    av_free(avStream);
    ///------   packet
    av_packet_unref(&packet);
    ///------   关闭解码器
    if (avCodecContext){
        avcodec_close(avCodecContext);
    };
    /// 关闭文件
//    if (avFormatContext){
//        avformat_close_input(&(avFormatContext));
//    };
    ///
    avformat_network_deinit();
    ///
    avcodec_free_context(&avCodecContext);
    _isRelease = YES;
}
#pragma mark ------------ property
#pragma mark ------ duration
- (int64_t)duration{
    return [AFOMediaTimer totalSecondsDuration:avFormatContext -> duration];
}
#pragma mark ------ currentTime
- (int64_t)currentTime{
    AVRational timeBase = avFormatContext->streams[_videoStream]->time_base;
    return packet.pts * (double)timeBase.num / timeBase.den;
}
#pragma mark ------ fps
- (float)fps{
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
@end
