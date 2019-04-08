//
//  AFOHPPlayerBaseView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPlayerBaseView.h"
@implementation AFOHPPlayerBaseView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubBaseview];
    }
    return self;
}
- (void)addSubBaseview{
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
}
#pragma mark ------
- (void)playMusicAction:(UIButton *)sender{
}
#pragma mark ------
- (void)changeButtonImage:(UIButton *)sender{
}
- (void)changeMusicAction:(UIButton *)sender{
}
#pragma mark ------------ property
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
- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.tag = 0;
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_play.png"]] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_pause.png"]] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
- (UIButton *)onButton{
    if (!_onButton) {
        _onButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _onButton.tag = 1;
        [_onButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_onSong.png"]] forState:UIControlStateNormal];
        [_onButton addTarget:self action:@selector(changeMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onButton;
}
- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.tag = 2;
        [_nextButton setImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_nextSong.png"]] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(changeMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
