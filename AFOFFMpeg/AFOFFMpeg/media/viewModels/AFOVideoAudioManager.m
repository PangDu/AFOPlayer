//
//  AFOVideoAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOVideoAudioManager.h"
#import "AFOMediaConditional.h"
#import "AFOPlayMediaManager.h"
#import "AFOAudioManager.h"

@interface AFOVideoAudioManager (){
    AVCodec             *avCodecVideo;
    AVCodec             *avCodecAudio;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContextVideo;
    AVCodecContext      *avCcodecContextAudio;
}
@property (nonatomic, assign)            NSInteger  videoStream;
@property (nonatomic, assign)            NSInteger  audioStream;
@end

@implementation AFOVideoAudioManager
#pragma mark ------ init
+ (instancetype)shareVideoAudioManager{
    static AFOVideoAudioManager *managerment;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerment = [[AFOVideoAudioManager alloc] init];
    });
    return managerment;
}
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}
+ (void)initialize{
    if (self == [AFOVideoAudioManager class]) {
        avcodec_register_all();
        av_register_all();
        avformat_network_init();
    }
}
#pragma mark ------ add method
- (void)registerBaseMethod:(NSString *)path{
    ///------
    avFormatContext = avformat_alloc_context();
    avformat_open_input(&avFormatContext, [path UTF8String], NULL, NULL);
    ///------------ video
    avCodecContextVideo = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContextVideo, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodecVideo = avcodec_find_decoder(avCodecContextVideo -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContextVideo, avCodecVideo, NULL);
    
    ///------------ audio
    avCcodecContextAudio = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCcodecContextAudio, avFormatContext -> streams[self.audioStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodecAudio = avcodec_find_decoder(avCcodecContextAudio -> codec_id);
    ///------ Open codec
    avcodec_open2(avCcodecContextAudio, avCodecAudio, NULL);
}
- (void)displayVedioForPath:(NSString *)strPath
                      block:(displayVedioFrameBlock)block{
    WeakObject(self);
    [AFOMediaConditional mediaSesourcesConditionalPath:strPath block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex) {
        if (error.code == 0) {
            weakself.videoStream = videoIndex;
            weakself.audioStream = audioIndex;
        }else{
            block(error, NULL, NULL, NULL, 0, 0);
            return;
        }
    }];
    ///------
    [self registerBaseMethod:strPath];
    ///------ display video
    [[AFOPlayMediaManager shareAFOPlayMediaManager] displayVedioCodec:avCodecVideo formatContext:avFormatContext codecContext:avCodecContextVideo index:self.videoStream block:^(NSError *error, UIImage *image, NSString *totalTime, NSString *currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
        block(error,image,totalTime,currentTime,totalSeconds,cuttentSeconds);
    }];
    ///------ play audio
    [[AFOAudioManager shareAFOAudioManager] playAudioCodec:avCodecAudio formatContext:avFormatContext codecContext:avCcodecContextAudio index:self.audioStream];
}
#pragma mark ------ dealloc
- (void)dealloc{
    
}
@end
