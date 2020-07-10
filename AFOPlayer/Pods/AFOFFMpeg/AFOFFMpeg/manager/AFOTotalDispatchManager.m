//
//  AFOTotalDispatchManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOTotalDispatchManager.h"
#import <AFOGitHub/INTUAutoRemoveObserver.h>
#import <AFOFoundation/AFOWeakInstance.h>
#import "AFOConfigurationManager.h"
#import "AFOMediaManager.h"
#import "AFOAudioManager.h"

@interface AFOTotalDispatchManager ()<AFOPlayMediaManager>
@property (nonatomic, assign)            NSInteger  videoStream;
@property (nonatomic, assign)            NSInteger  audioStream;
@property (nonatomic, assign)            BOOL       isFinish;
@property (nonnull, nonatomic, strong)   AFOAudioManager      *audioManager;
@property (nonnull, nonatomic, strong)   AFOMediaManager  *videoManager;
@end
@implementation AFOTotalDispatchManager
+ (void)initialize{
    av_register_all();
}
#pragma mark ------ init
- (instancetype)init{
    if (self = [super init]) {
        [INTUAutoRemoveObserver addObserver:self selector:@selector(playAudio) name:@"AFOMediaStartManagerNotifacation" object:nil];
        
        [INTUAutoRemoveObserver addObserver:self selector:@selector(suspendedAudioNotifacation:) name:@"AFOMediaSuspendedManager" object:nil];
        
    }
    return self;
}
- (void)displayVedioForPath:(NSString *)strPath
                      block:(displayVedioFrameBlock)block{
    WeakObject(self);
    [AFOConfigurationManager configurationStreamPath:strPath block:^(NSError * _Nonnull error, NSInteger videoIndex, NSInteger audioIndex) {
        StrongObject(self);
        self.videoStream = videoIndex;
        self.audioStream = audioIndex;
    }];
    ///--- play audio
    [AFOConfigurationManager configurationForPath:strPath stream:self.audioStream block:^(AVCodec * _Nonnull codec, AVFormatContext * _Nonnull format, AVCodecContext * _Nonnull context, NSInteger videoStream, NSInteger audioStream) {
        [self.audioManager audioFormatContext:format codecContext:context index:self.audioStream];
        [self playAudio];
    }];
    ///------ display video
    [AFOConfigurationManager configurationForPath:strPath stream:self.videoStream block:^(AVCodec * _Nonnull codec, AVFormatContext * _Nonnull format, AVCodecContext * _Nonnull context, NSInteger videoStream, NSInteger audioStream) {
        [self.videoManager displayVedioFormatContext:format codecContext:context index:self.videoStream block:^(NSError *error, UIImage *image, NSString *totalTime, NSString *currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
            block(error,image,totalTime,currentTime,totalSeconds,cuttentSeconds);
        }];
    }];
}
- (void)playAudio{
    [self.audioManager playAudio];
}
- (void)stopAudio{
    [self.audioManager stopAudio];
}
- (void)suspendedAudioNotifacation:(NSNotification *)notification{
    [self stopAudio];
}
#pragma mark ------ AFOPlayMediaManager
- (void)videoNowPlayingDelegate{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFORestartMeidaFileNotification" object:nil];
}
#pragma mark ------ property
- (AFOAudioManager *)audioManager{
    if (!_audioManager) {
        _audioManager = [[AFOAudioManager alloc] init];
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
    NSLog(@"AFOTotalDispatchManager dealloc");
}
@end
//@property (nonatomic, assign)            float      audioTimeStamp;
//@property (nonatomic, assign)            float      videoTimeStamp;
//@property (nonatomic, assign)            float      videoPosition;
//@property (nonatomic, assign)            CGFloat    tickCorrectionTime;
//@property (nonatomic, assign)            float      tickCorrectionPosition;
//@property (nonatomic, assign)            float      frameRate;

//- (void)correctionTime{
//    const NSTimeInterval correction = [self tickCorrection];
//    const NSTimeInterval time = MAX(self.videoPosition + correction, 0.01);
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [self correctionTime];
//    });
//    [self playAudio];
//}
//- (CGFloat)tickCorrection{
//    const NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
//    if (!_tickCorrectionTime) {
//        _tickCorrectionTime = now;
//        _tickCorrectionPosition = _videoTimeStamp;
//        return 0;
//    }
//    NSTimeInterval dPosition = _videoTimeStamp - _tickCorrectionPosition;
//    NSTimeInterval dTime = now - _tickCorrectionTime;
//    NSTimeInterval correction = dPosition - dTime;
//    if (correction > 1.f || correction < -1.f) {
//        correction = 0;
//        _tickCorrectionTime = 0;
//    }
//    return correction;
//}
//#pragma mark ------ delegate
//- (void)audioTimeStamp:(float)audioTime{
//    self.audioTimeStamp = audioTime;
//}
//- (void)videoTimeStamp:(float)videoTime
//position:(float)position
//frameRate:(float)frameRate{
//    self.videoTimeStamp = videoTime;
//    self.videoPosition = position;
//    self.frameRate = frameRate;
//    [self correctionTime];
//}
