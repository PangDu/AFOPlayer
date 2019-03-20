//
//  AFOHPAVPlayerView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPAVPlayerView.h"
#import "AFOMPMediaQuery.h"
#import "AFOHPAVPlayerHeader.h"
@interface AFOHPAVPlayerView ()<AFOHPAVPlayerDelegate,AFOHPAVPlayerViewDelegate,AFOProgressSliderManagerDelegate>
@property (nonatomic, strong) UIImageView               *revolveImageView;
@property (nonatomic, strong) UILabel                   *playTimeLabel;
@property (nonatomic, strong) UILabel                   *totalTimeLabel;
@property (nonatomic, strong) AFOProgressSliderManager  *sliderManager;
@property (nonatomic, strong) UIButton                  *onButton;
@property (nonatomic, strong) UIButton                  *playButton;
@property (nonatomic, strong) UIButton                  *nextButton;
@property (nonatomic, strong) AFOHPAVPlayer             *avPlayer;
@property (nonatomic, weak) id<AFOHPAVPlayerViewDelegate> delegate;
@end

@implementation AFOHPAVPlayerView
#pragma mark ------ initWithFrame
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)sender{
    if (self = [super initWithFrame:frame]) {
        _delegate = sender;
        [self addSubviews];
    }
    return self;
}
#pragma mark ------------
- (void)addSubviews{
    ///------
    self.backgroundColor = [UIColor greenColor];
    ///------ revolveImageView
    [self addSubview:self.revolveImageView];
    ///------ playTimeLabel
    [self addSubview:self.playTimeLabel];
    ///------ totalTimeLabel
    [self addSubview:self.totalTimeLabel];
    ///------ playButton
    [self addSubview:self.playButton];
    ///------ onButton
    [self addSubview:self.onButton];
    ///------ nextButton
    [self addSubview:self.nextButton];
    ///------
    [self viewsFrame];
}
- (void)viewsFrame{
    __weak __typeof(self) weakSelf = self;
    ///------ revolveImageView
    [self.revolveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo (100);
        make.width.height.mas_equalTo(260);
    }];
    ///------ playTimeLabel
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(weakSelf.revolveImageView.mas_bottom).offset(40);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(10);
    }];
    ///------ slider
    WeakObject(self);
    [self.sliderManager progressSliderManager:^(AFOProgressSlider *slider) {
        StrongObject(self);
        [self addSubview:slider];
        ///
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playTimeLabel.mas_right).offset(5);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 130);;
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.playTimeLabel.mas_centerY);;
        }];
        ///------ totalTimeLabel
        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(slider.mas_right).offset(5);
            make.top.mas_equalTo(self.revolveImageView.mas_bottom).offset(40);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(10);
        }];
    }];
    ///------ onButton
    [self.onButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.top.mas_equalTo(weakSelf.totalTimeLabel.mas_bottom).offset(70);
        make.width.height.mas_equalTo(40);
    }];
    ///------ nextButton
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-80);
        make.top.mas_equalTo(weakSelf.totalTimeLabel.mas_bottom).offset(70);
        make.width.height.mas_equalTo(40);
    }];
    ///------ playButton
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.nextButton.mas_centerY);
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
}
#pragma mark ------------
- (void)settingValue:(id)model dictionary:(NSDictionary *)dicionary{
    id object;
    if (dicionary != NULL) {
        [self.avPlayer settingData:model];
        object = [self.avPlayer modelFormDataArray];
    }else{
        object = model;
    }
    ///------
    [self.revolveImageView setImage:[AFOHPAVPlayer albumImageWithSize:CGSizeMake(CGRectGetWidth(self.revolveImageView.frame), CGRectGetHeight(self.revolveImageView.frame)) object:object]];
    ///------
    self.avPlayer.currentItem = object;
    [self.avPlayer addPlayerItem:object];
}
#pragma mark ----------- 释放
- (void)displayLinkPause{
    [self.avPlayer settingAVPlayerPause];
    [self.sliderManager freeDisplayLink];
}
#pragma mark ------
- (void)playMusicAction:(UIButton *)sender{
    [self changeButtonImage:sender];
    [self.avPlayer selectMusicPlayer:sender.tag];
    [self.sliderManager settingDisplayLink:!sender.selected];
}
#pragma mark ------
- (void)changeButtonImage:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle  imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_pause.png"]] forState:UIControlStateSelected];
    }else{
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle  imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_play.png"]] forState:UIControlStateNormal];
    }
}
#pragma mark ------
- (void)changeMusicAction:(UIButton *)sender{
    _playButton.selected = YES;
    [self changeButtonImage:_playButton];
    [self.sliderManager settingSliderPercent:0.0];
    self.playTimeLabel.text = @"00:00:00";
    [self.sliderManager settingDisplayLink:!_playButton.selected];
    [self.avPlayer selectMusicPlayer:sender.tag];
}
#pragma mark ------ 手动滑动
- (void)progressValueChange{
    [self.avPlayer changeSliderValue:self.sliderManager.sliderPercent];
}
#pragma mark ------------ AFOHPAVPlayerDelegate
- (void)audioTotalTime:(NSString *)totalTime{
    self.totalTimeLabel.text = totalTime;
}
- (void)audioPlayWithEnter{
    self.playButton.selected = YES;
    [self.sliderManager settingDisplayLink:NO];
    [self.avPlayer selectMusicPlayer:AFOHPAVPlayerSelectMusicPlay];
}
- (void)audioOperationPlay:(id)model{
    if (model) {
        [self settingValue:model dictionary:NULL];
        [self.delegate settingSongName:[AFOHPAVPlayer songName:model]];
    }else{
        [self.sliderManager freeDisplayLink];
        [self.avPlayer settingAVPlayerPause];
    }
}
#pragma mark ------ AFOProgressSliderManagerDelegate
- (void)displayLinkUpdateDelegate{
    WeakObject(self);
    [self.avPlayer updateProgressSlider:^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        StrongObject(self);
        [self.sliderManager settingProgressSlider:currentTime total:totalTime block:^(BOOL isEnd) {
            if (isEnd) {
                [self.sliderManager settingSliderPercent:0.0];
                self.playTimeLabel.text = @"00:00:00";
                ///------
                _playButton.selected = YES;
                [self changeButtonImage:_playButton];
                [self.avPlayer selectMusicPlayer:AFOHPAVPlayerSelectMusicNext];
            }else{
                self.playTimeLabel.text = [NSString stringWithFormat:@"%@",
                                           [self.avPlayer formatPlayTime:currentTime]];
            }
        }];
    }];
}
- (void)progressValueChangeDelegate{
    [self.avPlayer changeSliderValue:self.sliderManager.sliderPercent];
}
#pragma mark ------------ property
#pragma mark ------ revolveImageView
- (UIImageView *)revolveImageView{
    if (!_revolveImageView) {
        _revolveImageView = [[UIImageView alloc] init];
        [_revolveImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _revolveImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _revolveImageView.clipsToBounds  = YES;
        _revolveImageView.layer.cornerRadius = 130;
        _revolveImageView.layer.masksToBounds = YES;
        _revolveImageView.backgroundColor = [UIColor grayColor];
    }
    return _revolveImageView;
}
#pragma mark ------ playTimeLabel
- (UILabel *)playTimeLabel{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.text = @"00:00:00";
        _playTimeLabel.textColor = [UIColor blackColor];
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.font = [UIFont systemFontOfSize:10];
    }
    return _playTimeLabel;
}
#pragma mark ------ totalTimeLabel
- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
        _totalTimeLabel.text = @"00:00:00";
        _totalTimeLabel.textColor = [UIColor blackColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}
#pragma mark ------ playButton
- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.tag = AFOHPAVPlayerSelectMusicPlay;
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_play.png"]] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_pause.png"]] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
#pragma mark ------ onButton
- (UIButton *)onButton{
    if (!_onButton) {
        _onButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onButton.tag = AFOHPAVPlayerSelectMusicOn;
        [_onButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_onSong.png"]] forState:UIControlStateNormal];
        [_onButton addTarget:self action:@selector(changeMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onButton;
}
#pragma mark ------ nextButton
- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.tag = AFOHPAVPlayerSelectMusicNext;
        [_nextButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_nextSong.png"]] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(changeMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
#pragma mark ------ avPlayer
- (AFOHPAVPlayer *)avPlayer{
    if (!_avPlayer) {
        _avPlayer = [[AFOHPAVPlayer alloc] initWithDelegate:self];
    }
    return _avPlayer;
}
#pragma mark ------ sliderManager
- (AFOProgressSliderManager *)sliderManager{
    if (!_sliderManager) {
        _sliderManager = [[AFOProgressSliderManager alloc] initWithDelegate:self];
    }
    return _sliderManager;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPAVPlayerView class]));
}
@end
