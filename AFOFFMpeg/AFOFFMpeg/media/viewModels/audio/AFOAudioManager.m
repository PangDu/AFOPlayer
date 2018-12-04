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
#pragma mark ------ add method
- (void)playAudioCodec:(AVCodec *)codec
           formatContext:(AVFormatContext *)formatContext
            codecContext:(AVCodecContext *)codecContext
                   index:(NSInteger)index{
    ///---
    [[AFOAudioSession shareAFOAudioSession] settingCategory:AVAudioSessionCategoryPlayback];
    [[AFOAudioSession shareAFOAudioSession]settingSampleRate:codecContext ->sample_rate];
    [[AFOAudioSession shareAFOAudioSession] settingActive:YES];
    ///---
    [[AFOAudioSampling shareAFOAudioSampling] audioSamping:formatContext codecContext:codecContext codec:codec index:index];
}
- (void)stopAudioContent{
    
}
- (void)dealloc{
    NSLog(@"AFOAudioManager dealloc");
}
@end
