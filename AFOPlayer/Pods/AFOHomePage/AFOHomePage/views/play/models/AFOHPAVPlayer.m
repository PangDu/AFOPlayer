//
//  AFOHPAVPlayer.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPAVPlayer.h"
#import "AFOHPAVPlayer+ChooseSong.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AFOFoundation/AFOFoundation.h>
#import "AFOMPMediaQuery.h"
@interface AFOHPAVPlayer ()
@property (nonatomic, strong) AVPlayer      *avPlayer;
@property (nonatomic, strong) AVPlayerItem  *playerItem;
@end

@implementation AFOHPAVPlayer
#pragma mark ------------ initialize
+ (void)initialize{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
#pragma mark ------------ initWithDelegate
- (instancetype)initWithDelegate:(id)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}
#pragma mark ------------ 播放音频
- (void)audioPlayer{
    if (self.avPlayer.rate == 1.0) {
        [self.avPlayer pause];
    }else{
        [self.avPlayer play];
    }
}
#pragma mark ------------ 
- (void)settingAVPlayerPause:(BOOL)isPause{
    if (isPause) {
        [self.avPlayer pause];
    }else{
        [self.avPlayer play];
    }
}
#pragma mark ------------ 播放音乐
- (void)selectMusicPlayer:(AFOHPAVPlayerSelectMusic)type{
    WeakObject(self);
    switch (type) {
        case AFOHPAVPlayerSelectMusicPlay:
            [self audioPlayer];
            break;
        default:
            [self operationMusicPlayer:type block:^(id model) {
                StrongObject(self);
                [self.avPlayer pause];
                [self.delegate audioOperationPlay:model];
            }];
            break;
    }
}
#pragma mark ------------ 添加AVPlayer
- (void)addPlayerItem:(id)model{
    AVAsset *asset = [AVAsset assetWithURL:[AFOMPMediaQuery mediaItemPropertyAssetURL:model]];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    //添加监听
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
}
#pragma mark------------ 监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        [self.delegate audioTotalTime:[NSString formatPlayTime:CMTimeGetSeconds(playerItem.duration)]];
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
            [self.delegate audioPlayWithEnter];
            NSLog(@"playerItem is ready");
        } else{
            NSLog(@"load break");
        }
    }
}
#pragma mark ------
- (void)changeSliderValue:(CGFloat)percent{
    if (self.avPlayer.status == AVPlayerStatusReadyToPlay) {
        NSTimeInterval duration = percent* CMTimeGetSeconds(self.avPlayer.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        [self.avPlayer seekToTime:seekTime completionHandler:^(BOOL finished) {
            
        }];
    }
}
#pragma mark ------
- (void)updateProgressSlider:(void (^) (NSTimeInterval currentTime,
                                        NSTimeInterval totalTime))block{
    block(CMTimeGetSeconds(self.avPlayer.currentTime), CMTimeGetSeconds(self.avPlayer.currentItem.duration));
}
- (NSString *)totalTimer{
    return [NSString formatPlayTime:CMTimeGetSeconds(self.avPlayer.currentItem.duration)];
}
#pragma mark ------
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem{
    NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark ------ 移除观察者
- (void)removeAvPlayerObserver{
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
}
#pragma mark ------------ dealloc
- (void)dealloc{
    [self removeAvPlayerObserver];
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPAVPlayer class]));
}
#pragma mark ------------ 获取专辑图片
- (id)getCurrentSongImage:(id)model dictionary:(NSDictionary *)dictionary{
    if (dictionary != NULL) {
        [self settingData:model];
        model = [self modelFormDataArray];
    }else{
        model = model;
    }
    return model;
}
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object{
    return [AFOMPMediaQuery albumImageWithSize:size object:object];
}
#pragma mark ------------ 获取歌曲名
+ (NSString *)songName:(id)object{
    return [AFOMPMediaQuery songName:object];
}
@end
