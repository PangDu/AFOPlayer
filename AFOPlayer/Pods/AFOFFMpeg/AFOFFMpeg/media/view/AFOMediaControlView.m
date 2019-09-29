//
//  AFOMediaControlView.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaControlView.h"
#import <AFOViews/AFOViews.h>
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
@interface AFOMediaControlView ()
@property (nonnull,nonatomic, strong) UIButton                  *playButton;
@property (nonnull,nonatomic, strong) UILabel                   *timeLabel;
@property (nonnull,nonatomic, strong) AFOProgressSliderManager  *sliderManager;
@property (nonatomic, weak) id<AFOMediaControlViewDelegate>   delegate;
@end


@implementation AFOMediaControlView

#pragma mark ------------ init
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _delegate = delegate;
        [self addSubviews:frame];
    }
    return self;
}
#pragma mark ------------ custom
#pragma mark ------
- (void)addSubviews:(CGRect)frame{
    self.backgroundColor = [UIColor yellowColor];
    ///------
    [self addSubview:self.playButton];
    ///------
    [self addSubview:self.timeLabel];
    ///------
    [self addViewFrames];
    ///------
    WeakObject(self);
    [self.sliderManager progressSliderManager:^(AFOProgressSlider *slider) {
        StrongObject(self);
        [self addSubview:slider];
        ///------ progessSlider
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playButton.mas_right).offset(10);
            make.right.equalTo(self.timeLabel.mas_left).offset(-10);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self);
        }];
    }];
}
#pragma mark ------
- (void)addViewFrames{
    ///------ playButton
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(72);
    }];
    ///------ timeLabel
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(labelsize.width + 5);
    }];
}
#pragma mark ------
- (void)settingPlayButtonPause{
    [self buttonTouchAction:self.playButton];
}
- (void)settingTime:(NSString *)totalTime
        currentTime:(NSString *)currentTime
              total:(NSInteger)total
            current:(NSInteger)current
              block:(void (^)(BOOL))block{
    WeakObject(self);
    [self.sliderManager settingProgressSlider:current total:total block:^(BOOL isEnd) {
        StrongObject(self);
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",currentTime,totalTime];
        ///------
        if (isEnd) {
            self.playButton.selected = YES;
            [self buttonTouchAction:self.playButton];
        }
        ///------
        block(isEnd);
    }];
}
#pragma mark ------ 播放
- (void)buttonTouchAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOPlayer.bundle" source:@"pauseBtn.png"]] forState:UIControlStateSelected];
    }else{
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOPlayer.bundle" source:@"playBtn.png"]] forState:UIControlStateNormal];
    }
}
#pragma mark ------
- (void)buttonEventAction:(UIButton *)sender{
    [self buttonTouchAction:sender];
    [self.delegate buttonTouchActionDelegate:sender.selected];
}
#pragma mark ------------ property
#pragma mark ------ playButton
- (UIButton *)playButton{
    if (!_playButton){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton addTarget:self action:@selector(buttonEventAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOPlayer.bundle" source:@"playBtn.png"]] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOPlayer.bundle" source:@"pauseBtn.png"]] forState:UIControlStateSelected];
    }
    return _playButton;
}
#pragma mark ------ nowLabel
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.text = @"00:00:00/00:00:00";
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
#pragma mark ------ sliderManager
- (AFOProgressSliderManager *)sliderManager{
    if (!_sliderManager) {
        _sliderManager = [[AFOProgressSliderManager alloc] init];
    }
    return _sliderManager;
}
- (void)dealloc{
    NSLog(@"dealloc AFOMediaControlView");
}
@end
