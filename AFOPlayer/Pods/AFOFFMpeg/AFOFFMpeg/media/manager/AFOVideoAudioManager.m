//
//  AFOVideoAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOVideoAudioManager.h"
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
#import "AFOMediaConditional.h"
#import "AFONewMediaManager.h"
/* no AV sync correction is done if below the minimum AV sync threshold */
#define AV_SYNC_THRESHOLD_MIN 0.04
/* AV sync correction is done if above the maximum AV sync threshold */
#define AV_SYNC_THRESHOLD_MAX 0.1
/* If a frame duration is longer than this, it will not be duplicated to compensate AV sync */
#define AV_SYNC_FRAMEDUP_THRESHOLD 0.1
/* no AV correction is done if too big error */
#define AV_NOSYNC_THRESHOLD 10.0

@interface AFOVideoAudioManager ()<AFOAudioManagerDelegate,AFOPlayMediaManager>{
    AVCodec             *avCodecVideo;
    AVCodec             *avCodecAudio;
    AVFormatContext     *avVideoFormatContext;
    AVFormatContext     *avAudioFormatContext;
    AVCodecContext      *avCodecContextVideo;
    AVCodecContext      *avCcodecContextAudio;
}

@end

@implementation AFOVideoAudioManager
#pragma mark ------ init
+ (void)initialize{
    if (self == [AFOVideoAudioManager class]) {
        av_register_all();
    }
}
#pragma mark ------ add method
- (void)registerBaseMethod:(NSString *)path{
    [INTUAutoRemoveObserver addObserver:self selector:@selector(stopAudioNotifacation:) name:@"AFOMediaStopManager" object:nil];
    ///------------ video
    avVideoFormatContext = avformat_alloc_context();
    avformat_open_input(&avVideoFormatContext, [path UTF8String], NULL, NULL);
    avCodecContextVideo = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContextVideo, avVideoFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodecVideo = avcodec_find_decoder(avCodecContextVideo -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContextVideo, avCodecVideo, NULL);
    
    ///------------ audio
    avAudioFormatContext = avformat_alloc_context();
    avformat_open_input(&avAudioFormatContext, [path UTF8String], NULL, NULL);
    avCcodecContextAudio = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCcodecContextAudio, avAudioFormatContext -> streams[self.audioStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodecAudio = avcodec_find_decoder(avCcodecContextAudio -> codec_id);
    ///------ Open codec
    avcodec_open2(avCcodecContextAudio, avCodecAudio, NULL);
}
- (void)displayVedioForPath:(NSString *)strPath
                      block:(displayVedioFrameBlock)block{
    WeakObject(self);
    [AFOMediaConditional mediaSesourcesConditionalPath:strPath block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex){
        StrongObject(self);
        if (error.code == 0) {
            self.videoStream = videoIndex;
            self.audioStream = audioIndex;
        }else{
            block(error, NULL, NULL, NULL, 0, 0);
            return;
        }
    }];
    ///------
    [self registerBaseMethod:strPath];
    ///------ play audio
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.audioManager audioFormatContext:self->avAudioFormatContext codecContext:self->avCcodecContextAudio index:self.audioStream];
        [self playAudio];
    });
    ///------ display video
    [self.videoManager displayVedioFormatContext:avVideoFormatContext codecContext:avCodecContextVideo index:self.videoStream block:^(NSError *error, UIImage *image, NSString *totalTime, NSString *currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
        block(error,image,totalTime,currentTime,totalSeconds,cuttentSeconds);
    }];
}
- (void)playAudio{
    [self.audioManager playAudio];
}
- (void)stopAudio{
    [self.audioManager stopAudio];
}
- (void)stopAudioNotifacation:(NSNotification *)notification{
    [self stopAudio];
}
- (void)correctionTime{
    const NSTimeInterval correction = [self tickCorrection];
    const NSTimeInterval time = MAX(self.videoPosition + correction, 0.01);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self correctionTime];
    });
    [self playAudio];
}
- (CGFloat)tickCorrection{
    const NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if (!_tickCorrectionTime) {
        _tickCorrectionTime = now;
        _tickCorrectionPosition = _videoTimeStamp;
        return 0;
    }
    NSTimeInterval dPosition = _videoTimeStamp - _tickCorrectionPosition;
    NSTimeInterval dTime = now - _tickCorrectionTime;
    NSTimeInterval correction = dPosition - dTime;
    if (correction > 1.f || correction < -1.f) {
        correction = 0;
        _tickCorrectionTime = 0;
    }
    return correction;
}
#pragma mark ------ delegate
- (void)audioTimeStamp:(float)audioTime{
    self.audioTimeStamp = audioTime;
}
- (void)videoTimeStamp:(float)videoTime
              position:(float)position
             frameRate:(float)frameRate{
    self.videoTimeStamp = videoTime;
    self.videoPosition = position;
    self.frameRate = frameRate;
   [self correctionTime];
}
#pragma mark ------ attribute
- (AFOAudioManager *)audioManager{
    if (!_audioManager) {
        _audioManager = [[AFOAudioManager alloc] initWithDelegate:self];
    }
    return _audioManager;
}
- (AFOMediaManager *)videoManager{
    if (!_videoManager) {
        _videoManager = [[AFOMediaManager alloc] initWithDelegate:self];
    }
    return _videoManager;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOVideoAudioManager dealloc");
}
@end
