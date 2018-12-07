//
//  AFOAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioManager.h"
#import "AFOAudioThreadDecoder.h"
#import "AFOAudioSession.h"
#import "AFOAudioDecoder.h"
#import "AFOAudioOutPut.h"

@interface AFOAudioManager ()<AFOAudioFillDataDelegate>
@property (nonatomic, assign)                NSInteger         channel;
@property (nonnull, nonatomic, strong)  AFOAudioOutPut        *audioOutPut;
@property (nonnull, nonatomic, strong)  AFOAudioThreadDecoder *threadDecoder;
@end
@implementation AFOAudioManager
#pragma mark ------  method
- (void)audioCodec:(AVCodec *)codec
           formatContext:(AVFormatContext *)formatContext
            codecContext:(AVCodecContext *)codecContext
                   index:(NSInteger)index{
    self.channel = codecContext -> channels;
    [self settingAudioSession:codecContext];
    ///---
    [self.threadDecoder packetBufferTimePercent:0.02f];
    [self.threadDecoder audioDecoder:formatContext codecContext:codecContext codec:codec index:index];
    ///---
    _audioOutPut = [[AFOAudioOutPut alloc] initWithChannel:codecContext -> channels sampleRate:codecContext -> sample_rate bytesPerSample:2 delegate:self];
}
- (void)settingAudioSession:(AVCodecContext *)codecContext{
    [[AFOAudioSession shareAFOAudioSession] settingCategory:AVAudioSessionCategoryPlayback];
    [[AFOAudioSession shareAFOAudioSession]settingSampleRate:codecContext ->sample_rate];
    [[AFOAudioSession shareAFOAudioSession] settingActive:YES];
    [[AFOAudioSession shareAFOAudioSession] settingPreferredLatency:1*1024.0/codecContext ->sample_rate];
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
        [_threadDecoder readAudioPacket:sampleBuffer size:(int)(frame * self.channel)];
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
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOAudioManager dealloc");
}
@end
