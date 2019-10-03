//
//  AFOAudioSession.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioSession.h"
#import <AVFoundation/AVFoundation.h>
#import <AFOGitHub/AFOGitHub.h>

@interface AFOAudioSession()
@property (nonnull, nonatomic, strong) AVAudioSession *audioSession;
@property (nonnull, nonatomic, strong) NSString       *category;
@property (nonatomic, assign) NSTimeInterval preferredLatency;
@property (nonatomic, assign) Float64        defaultSampleRate;
@property (nonatomic, assign) Float64        currentSampleRate;
@property (nonatomic, assign) BOOL           active;
@end

@implementation AFOAudioSession
#pragma mark ------ init
- (instancetype)init{
    if (self = [super init]) {
        _defaultSampleRate = 44100.0;
        _currentSampleRate = _defaultSampleRate;
        _audioSession = [AVAudioSession sharedInstance];
        [self addRouteChangeNotification];
    }
    return self;
}
#pragma mark ------ add method
- (void)addRouteChangeNotification{
    [INTUAutoRemoveObserver addObserver:self selector:@selector(audioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
}
- (void)audioSessionRouteChangeNotification:(NSNotification *)notification{
    NSLog(@"audioSessionRouteChangeNotification===%@",notification);
}
#pragma mark ------ attribute assignment
- (void)settingSampleRate:(Float64)sampleRate{
    _currentSampleRate = sampleRate;
}
- (void)settingCategory:(NSString *)category{
    _category = category;
    NSError *error = nil;
    if ( ![self.audioSession setCategory:_category error:&error] ) {
        NSLog(@"Could note set category on audio session: %@ ", error.localizedDescription);
    }
}
- (void)settingPreferredLatency:(NSTimeInterval)preferredLatency{
    
    _preferredLatency = preferredLatency;
    
    NSError *error = nil;
    
    if ( ![self.audioSession setPreferredIOBufferDuration:_preferredLatency error:&error] ){
        NSLog(@"Error when setting preferred I/O buffer duration");
    }
}
- (void)settingActive:(BOOL)active{
    _active = active;
    NSError *error = nil;
    ///---
    if ( ![self.audioSession setPreferredSampleRate:self.defaultSampleRate error:&error] ){
        NSLog(@"Error when setting sample rate on audio session: %@", error.localizedDescription);
    }
    ///---
    if ( ![self.audioSession setActive:_active error:&error] ){
        NSLog(@"Error when setting active state of audio session: %@", error.localizedDescription);
    }
    _currentSampleRate = [self.audioSession sampleRate];
}
- (void)dealloc{
    NSLog(@"AFOAudioSession dealloc");
}
@end
