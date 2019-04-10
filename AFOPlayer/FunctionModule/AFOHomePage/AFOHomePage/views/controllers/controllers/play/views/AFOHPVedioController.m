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
#import "AFOHPPlayPresenterView.h"
#import "AFOHPPlayPresenterBusiness.h"
@interface AFOHPVedioController ()<AFORouterManagerDelegate,AFOHPAVPlayerViewDelegate,AFOHPAVPlayerDelegate,AFOProgressSliderManagerDelegate>
@property (nonatomic, strong) AFOHPAVPlayer             *hpAVPlayer;
@property (nonatomic, strong) AFOProgressSliderManager  *sliderManager;
@property (nonatomic, strong) AFOHPAVPlayerView         *hpAVPlayerView;
@property (nonatomic, strong) AFOHPPlayPresenterView     *presenterView;
@property (nonatomic, strong) AFOHPPlayPresenterBusiness *pressenterBusiness;
@end

@implementation AFOHPVedioController
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
- (void)playMusicActionDelegate:(BOOL)isPlay{
    [self.sliderManager settingDisplayLink:isPlay];
    [self.hpAVPlayer settingAVPlayerPause:isPlay];
}
#pragma mark ------ AFOHPAVPlayerDelegate
- (void)audioTotalTime:(NSString *)totalTime{
    [self.sliderManager settingDisplayLink:NO];
}
- (void)audioPlayWithEnter{
    [self.hpAVPlayer selectMusicPlayer:0];
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
                [self.hpAVPlayerView settingDefaultTimer];
                [self.hpAVPlayer selectMusicPlayer:AFOHPAVPlayerSelectMusicNext];
            }else{
                self.hpAVPlayerView.timeBlock([NSString stringWithFormat:@"%@",
                                               [self.hpAVPlayer formatPlayTime:totalTime]],[NSString stringWithFormat:@"%@",
                                                                                              [self.hpAVPlayer formatPlayTime:currentTime]]);
            }
        }];
    }];
}
- (void)progressValueChangeDelegate{
    [self.sliderManager settingSliderPercent:self.sliderManager.sliderPercent];
}
#pragma mark ------------ didReceiveMemoryWarning
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
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFOHPPlayPresenterView alloc] init];
    }
    return _presenterView;
}
- (AFOHPPresenter *)pressenterBusiness{
    if (!_pressenterBusiness) {
        _pressenterBusiness = [[AFOHPPlayPresenterBusiness alloc] init];
    }
    return _pressenterBusiness;
}
- (void)dealloc{
    [self.sliderManager settingDisplayLink:YES];
    [self.sliderManager freeDisplayLink];
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPVedioController class]));
}
@end
