//
//  AFOAudioManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioManager.h"
#import "AFOAudioSession.h"

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
- (void)playAudioContent{
    [AFOAudioSession shareAFOAudioSession];
}
- (void)stopAudioContent{
    
}
- (void)dealloc{
    NSLog(@"AFOAudioManager dealloc");
}
@end
