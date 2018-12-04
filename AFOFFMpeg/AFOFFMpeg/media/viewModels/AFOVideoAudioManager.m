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
    AVCodec             *avcodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
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
    avformat_open_input(&avFormatContext, [path UTF8String], NULL, NULL);
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avcodec = avcodec_find_decoder(avCodecContext -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContext, avcodec, NULL);
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
    [[AFOPlayMediaManager shareAFOPlayMediaManager] displayVedioCodec:avcodec formatContext:avFormatContext codecContext:avCodecContext index:self.videoStream block:^(NSError *error, UIImage *image, NSString *totalTime, NSString *currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
        block(error,image,totalTime,currentTime,totalSeconds,cuttentSeconds);
    }];
    ///------ play audio
}
#pragma mark ------ dealloc
- (void)dealloc{
    
}
@end
