//
//  AFOHPPlayerView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPPlayerView.h"
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
@interface AFOHPPlayerView ()<AFOHPAVPlayerViewDelegate>
@property (nonatomic, assign, readwrite) CGSize          imageSize;
@property (nonatomic, weak) id<AFOHPAVPlayerViewDelegate> delegate;
@end

@implementation AFOHPPlayerView
#pragma mark ------ initWithFrame
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)sender{
    if (self = [super initWithFrame:frame]) {
        _delegate = sender;
        [self addSubBaseview];
    }
    return self;
}
#pragma mark ------ addSubBaseview
- (void)addSubBaseview{
    ///---
    [self addSubview:self.backImageView];
    ///--- revolveImageView
    [self addSubview:self.revolveImageView];
    ///--- playTimeLabel
    [self addSubview:self.playTimeLabel];
    ///--- totalTimeLabel
    [self addSubview:self.totalTimeLabel];
    ///--- playButton
    [self addSubview:self.playButton];
    ///--- onButton
    [self addSubview:self.onButton];
    ///--- nextButton
    [self addSubview:self.nextButton];
    ///---
    [self viewsFrame];
}
#pragma mark ------------ viewsFrame
- (void)viewsFrame{
    WeakObject(self);
    ///---
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height);
    }];
    ///------ revolveImageView
    [self.revolveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo (100);
        make.width.height.mas_equalTo(260);
    }];
    ///--- playTimeLabel
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.revolveImageView.mas_bottom).offset(40);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(10);
    }];
    ///------ slider
    self.sliderBlock = ^(id model) {
        StrongObject(self);
        UIControl *view = model;
        [self addSubview:view];
        ///---
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playTimeLabel.mas_right).offset(15);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 180);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.playTimeLabel.mas_centerY);;
        }];
        ///------ totalTimeLabel
        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_right).offset(10);
            make.top.mas_equalTo(self.revolveImageView.mas_bottom).offset(40);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(10);
        }];
    };
    ///------ onButton
    [self.onButton mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.left.mas_equalTo(80);
        make.top.mas_equalTo(self.totalTimeLabel.mas_bottom).offset(70);
        make.width.height.mas_equalTo(40);
    }];
    ///------ nextButton
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.right.mas_equalTo(-80);
        make.top.mas_equalTo(self.totalTimeLabel.mas_bottom).offset(70);
        make.width.height.mas_equalTo(40);
    }];
    ///------ playButton
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongObject(self);
        make.centerY.mas_equalTo(self.nextButton.mas_centerY);
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    ///---
    self.imageSize = CGSizeMake(260, 260);
    ///---
    [self runBlockAction];
}
- (void)runBlockAction{
    WeakObject(self);
    self.timeBlock = ^(NSString *totalTime,NSString *playTime) {
        StrongObject(self);
        self.totalTimeLabel.text = totalTime;
        self.playTimeLabel.text = playTime;
    };
    ///---
    [self.playButton setSelected:YES];
}
#pragma mark ------
- (void)playMusicAction:(UIButton *)sender{
    [self.delegate playMusicActionDelegate:sender.selected];
    [self changeButtonImage:sender];
}
#pragma mark ------
- (void)changeButtonImage:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle  imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_pause.png"]] forState:UIControlStateSelected];
    }else{
        [self.playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle  imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_play.png"]] forState:UIControlStateNormal];
    }
}
#pragma mark ------
- (void)changeMusicAction:(UIButton *)sender{
    self.playButton.selected = YES;
    [self changeButtonImage:self.playButton];
//    [self.sliderManager settingSliderPercent:0.0];
    self.playTimeLabel.text = @"00:00:00";
//    [self.sliderManager settingDisplayLink:!_playButton.selected];
//    [self.avPlayer selectMusicPlayer:sender.tag];
}
#pragma mark ------------ AFOHPAVPlayerDelegate
- (void)audioOperationPlay:(id)model{
    if (model) {
//        [self settingValue:model dictionary:NULL];
//        [self.delegate settingSongName:[AFOHPAVPlayer songName:model]];
    }else{
//        [self.sliderManager freeDisplayLink];
//        [self.avPlayer settingAVPlayerPause];
    }
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPPlayerView class]));
}
@end
