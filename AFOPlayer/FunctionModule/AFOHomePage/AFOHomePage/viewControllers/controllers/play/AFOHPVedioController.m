//
//  AFOHPVedioController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPVedioController.h"
#import "AFOHPAVPlayer+ChooseSong.h"
#import "AFOHPAVPlayer.h"
#import "AFOHPAVPlayerView.h"
@interface AFOHPVedioController ()<AFORouterManagerDelegate,AFOHPAVPlayerViewDelegate,AFOHPAVPlayerDelegate,AFOProgressSliderManagerDelegate>
@property (nonatomic, strong) AFOHPAVPlayer             *hpAVPlayer;
@property (nonatomic, strong) AFOProgressSliderManager  *sliderManager;
@property (nonatomic, strong) AFOHPAVPlayerView         *hpAVPlayerView;
@end

@implementation AFOHPVedioController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen] .applicationFrame];
    self.view = view;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model
                                        parameters:(NSDictionary *)parameters{
    self.title = [parameters objectForKey:@"title"];
    ///---
    WeakObject(self);
    [self.sliderManager progressSliderManager:^(AFOProgressSlider *slider) {
        StrongObject(self);
        self.hpAVPlayerView.sliderBlock(slider);
    }];
    ///---
    self.hpAVPlayer.currentItem = [self.hpAVPlayer getCurrentSongImage:model dictionary:parameters];
    [self.hpAVPlayer addPlayerItem:[self.hpAVPlayer getCurrentSongImage:model dictionary:parameters]];
    
    self.hpAVPlayerView.block([AFOHPAVPlayer albumImageWithSize:self.hpAVPlayerView.imageSize object:[self.hpAVPlayer getCurrentSongImage:model dictionary:parameters]]);
    [self.view addSubview:self.hpAVPlayerView];
}
#pragma mark ------ AFOHPAVPlayerViewDelegate
- (void)settingSongName:(NSString *)name{
    self.title = name;
}
- (void)progressValueChangeDelegate:(CGFloat)percent{
    [self.hpAVPlayer changeSliderValue:percent];
}
#pragma mark ------ AFOHPAVPlayerDelegate
- (void)audioTotalTime:(NSString *)totalTime{
    self.hpAVPlayerView.totalTimeBlock(totalTime);
    [self.sliderManager settingDisplayLink:NO];
}
- (void)audioPlayWithEnter{
    [self.hpAVPlayer selectMusicPlayer:0];
    self.hpAVPlayerView.enterBlock();
}
- (void)audioOperationPlay:(id)model{
    
}
#pragma mark ------ AFOProgressSliderManagerDelegate
- (void)displayLinkUpdateDelegate{
    WeakObject(self);
    [self.hpAVPlayer updateProgressSlider:^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        StrongObject(self);
        [self.sliderManager settingProgressSlider:currentTime total:totalTime block:^(BOOL isEnd) {
            if (isEnd) {
                [self.sliderManager settingSliderPercent:0.0];
                self.hpAVPlayerView.playTimeBlock(@"00:00:00",YES);
                ///------
                [self.hpAVPlayer selectMusicPlayer:AFOHPAVPlayerSelectMusicNext];
            }else{
                self.hpAVPlayerView.playTimeBlock([NSString stringWithFormat:@"%@",
                                                   [self.hpAVPlayer formatPlayTime:currentTime]],YES);
            }
        }];
    }];
}
- (void)progressValueChangeDelegate{
    [self.hpAVPlayer changeSliderValue:self.sliderManager.sliderPercent];
}
#pragma mark ------------ system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- property
- (AFOHPAVPlayer *)hpAVPlayer{
    if (!_hpAVPlayer) {
        _hpAVPlayer = [[AFOHPAVPlayer alloc] initWithDelegate:self];
    }
    return _hpAVPlayer;
}
- (AFOProgressSliderManager *)sliderManager{
    if (!_sliderManager) {
        _sliderManager = [[AFOProgressSliderManager alloc] initWithDelegate:self];
    }
    return _sliderManager;
}
- (AFOHPAVPlayerView *)hpAVPlayerView{
    if (!_hpAVPlayerView) {
        _hpAVPlayerView = [[AFOHPAVPlayerView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) delegate:self];
    }
    return _hpAVPlayerView;
}
- (void)dealloc{
    [self.sliderManager settingDisplayLink:YES];
    [self.sliderManager freeDisplayLink];
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPVedioController class]));
}
@end
