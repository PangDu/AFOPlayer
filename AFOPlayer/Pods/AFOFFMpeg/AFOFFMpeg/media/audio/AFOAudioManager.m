//
//  AFOAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AFOFoundation/AFOFoundation.h>
#import "AFOAudioThreadDecoder.h"
#import "AFOAudioSession.h"
#import "AFOAudioDecoder.h"
#import "AFOAudioOutPut.h"

@interface AFOAudioManager ()<AFOAudioFillDataDelegate>
@property (nonatomic, assign)                NSInteger         channel;
@property (nonnull, nonatomic, strong)  AFOAudioOutPut        *audioOutPut;
@property (nonnull, nonatomic, strong)  AFOAudioThreadDecoder *threadDecoder;
@property (nonnull, nonatomic, strong)  AFOAudioSession       *audioSession;
@property (nonatomic, weak) id<AFOAudioManagerDelegate> delegate;
@end
@implementation AFOAudioManager
#pragma mark ------ init
- (instancetype)initWithDelegate:(id<AFOAudioManagerDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}
#pragma mark ------  method
- (void)audioFormatContext:(AVFormatContext *)formatContext
              codecContext:(AVCodecContext *)codecContext
                     index:(NSInteger)index{
    self.channel = codecContext -> channels;
    [self settingAudioSession:codecContext];
    ///---
    [self.threadDecoder packetBufferTimePercent:0.02f];
    [self.threadDecoder audioDecoder:formatContext codecContext:codecContext index:index];
    ///---
    _audioOutPut = [[AFOAudioOutPut alloc] initWithChannel:codecContext -> channels sampleRate:codecContext -> sample_rate bytesPerSample:2 delegate:self];
}
- (void)settingAudioSession:(AVCodecContext *)codecContext{
    [self.audioSession settingCategory:AVAudioSessionCategoryPlayback];
    [self.audioSession settingSampleRate:codecContext ->sample_rate];
    [self.audioSession settingActive:YES];
    [self.audioSession settingPreferredLatency:1*1024.0/codecContext ->sample_rate];
}
- (void)playAudio{
    [self.audioOutPut audioPlay];
}
- (void)stopAudio{
    [self.audioOutPut audioStop];
}
#pragma mark ------ delegate
- (NSInteger)fillAudioData:(SInt16 *_Nullable)sampleBuffer
                    frames:(NSInteger)frame
                  channels:(NSInteger)channel{
    memset(sampleBuffer, 0, frame * self.channel * sizeof(SInt16));
    if (_threadDecoder) {
        WeakObject(self);
        [_threadDecoder readAudioPacket:sampleBuffer size:(int)(frame * self.channel) block:^(float timeStamp) {
            [weakself.delegate audioTimeStamp:timeStamp];
        }];
    }
    return 1;
}
#pragma mark ------ attribute
- (AFOAudioThreadDecoder *)threadDecoder{
    if (!_threadDecoder) {
        _threadDecoder = [[AFOAudioThreadDecoder alloc] init];
    }
    return _threadDecoder;
}
- (AFOAudioSession *)audioSession{
    if (!_audioSession) {
        _audioSession = [[AFOAudioSession alloc] init];
    }
    return _audioSession;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOAudioManager dealloc");
}
@end
