//
//  AFOHPPlayPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPlayPresenterView.h"
#import "AFOHPPlayerView.h"
@interface AFOHPPlayPresenterView ()<AFOHPAVPlayerViewDelegate>
@property (nonatomic, strong) AFOProgressSliderManager  *sliderManager;
@property (nonatomic, strong) AFOHPPlayerView           *playerView;
@property (nonatomic, weak) id<AFOHPPresenterDelegate,AFOHPPlayPresenterViewDelegate> viewDelegate;
@end

@implementation AFOHPPlayPresenterView
- (instancetype)initWithDelegate:(id<AFOHPPlayPresenterViewDelegate>)delegate{
    if (self = [super initWithDelegate:delegate]) {
        _viewDelegate = delegate;
    }
    return self;
}
#pragma mark ------ bindingView
- (void)bindingPlayerView{
    [self.sliderManager progressSliderManager:^(AFOProgressSlider *slider) {
        self.playerView.sliderBlock(slider);
        [self.presenterDelegate bindingView:self.playerView];
    }];
}
#pragma mark ------ settingTotalTime
- (void)settingTotalTime:(NSString *)totalTime{
    self.playerView.timeBlock(totalTime,@"00:00:00");
    [self.sliderManager settingDisplayLink:NO];
}
#pragma mark ------
- (void)setttingPlayTimer:(NSTimeInterval)currentTime
                totalTime:(NSTimeInterval)totalTime{
    [self.sliderManager settingProgressSlider:currentTime total:totalTime block:^(BOOL isEnd) {
        if (isEnd) {
            [self.playerView settingDefaultTimer];
        }else{
            self.playerView.timeBlock([NSString formatPlayTime:totalTime],[NSString formatPlayTime:currentTime]);
            ;
        }
    }];
}
#pragma mark ------ AFOHPAVPlayerViewDelegate
- (void)playMusicActionDelegate:(BOOL)isPlay{
    [self.sliderManager settingDisplayLink:isPlay];
    [self.viewDelegate musicPlayActionDelegate:isPlay];
}
#pragma mark ------ AFOProgressSliderManagerDelegate
- (void)displayLinkUpdateDelegate{
    [self.viewDelegate updateProgressSliderDelegate];
}
- (void)progressValueChangeDelegate{
    NSLog(@"progressValueChangeDelegate");
    [self.sliderManager settingSliderPercent:self.sliderManager.sliderPercent];
}
#pragma mark ------ property
- (AFOProgressSliderManager *)sliderManager{
    if (!_sliderManager) {
        _sliderManager = [[AFOProgressSliderManager alloc] initWithDelegate:self];
    }
    return _sliderManager;
}
- (AFOHPPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[AFOHPPlayerView alloc] initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) delegate:self];
    }
    return _playerView;
}
- (void)dealloc{
    [self.sliderManager settingDisplayLink:YES];
    [self.sliderManager freeDisplayLink];
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPPlayPresenterView class]));
}
@end
