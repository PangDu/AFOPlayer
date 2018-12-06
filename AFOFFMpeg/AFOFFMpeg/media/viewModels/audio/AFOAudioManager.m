//
//  AFOAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioManager.h"
#import "AFOAudioSession.h"
#import "AFOAudioSampling.h"
#import "AFOAudioOutPut.h"

@interface AFOAudioManager ()<AFOAudioFillDataDelegate>
@property (nonatomic, assign)   NSInteger chanel;
@property (nonnull, nonatomic, strong)  AFOAudioOutPut *audioOutPut;
@end

@implementation AFOAudioManager
#pragma mark ------ init
+ (instancetype)shareAFOAudioManager{
    static AFOAudioManager *audioManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioManager = [[AFOAudioManager alloc] init];
    });
    return audioManager;
}
#pragma mark ------  method
- (void)playAudioCodec:(AVCodec *)codec
           formatContext:(AVFormatContext *)formatContext
            codecContext:(AVCodecContext *)codecContext
                   index:(NSInteger)index{
    self.chanel = codecContext -> channels;
    [self settingAudioSession:codecContext];
    ///---
    [[AFOAudioSampling shareAFOAudioSampling] audioSamping:formatContext codecContext:codecContext codec:codec index:index];
    ///---
    _audioOutPut = [[AFOAudioOutPut alloc] initWithChannel:codecContext -> channels sampleRate:codecContext -> sample_rate bytesPerSample:2 delegate:self];
}
- (void)settingAudioSession:(AVCodecContext *)codecContext{
    [[AFOAudioSession shareAFOAudioSession] settingCategory:AVAudioSessionCategoryPlayback];
    [[AFOAudioSession shareAFOAudioSession]settingSampleRate:codecContext ->sample_rate];
    [[AFOAudioSession shareAFOAudioSession] settingActive:YES];
    [[AFOAudioSession shareAFOAudioSession] settingPreferredLatency:1*1024.0/codecContext ->sample_rate];
}
#pragma mark ------ delegate
- (NSInteger)fillAudioData:(SInt16 *_Nullable)sampleBuffer
                    frames:(NSInteger)frame
                  channels:(NSInteger)channel{
    memset(sampleBuffer, 0, frame * self.chanel * sizeof(SInt16));
    
//    if (_dec) {
//        [_dec readSamples:sampleBuffer size:(int)(frame * self.channel)];
//    }
    return 1;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOAudioManager dealloc");
}
@end
