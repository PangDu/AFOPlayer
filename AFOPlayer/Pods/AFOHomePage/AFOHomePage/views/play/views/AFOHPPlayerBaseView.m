//
//  AFOHPPlayerBaseView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPlayerBaseView.h"
#import <AFOFoundation/AFOFoundation.h>
@implementation AFOHPPlayerBaseView
#pragma mark ------ playMusicAction
- (void)playMusicAction:(UIButton *)sender{
}
#pragma mark ------
- (void)changeButtonImage:(UIButton *)sender{
}
- (void)changeMusicAction:(UIButton *)sender{
}
#pragma mark ------ settingDefaultTimer
- (void)settingDefaultTimer{
    self.totalTimeLabel.text = @"00:00:00";
    self.playTimeLabel.text = @"00:00:00";
}
#pragma mark ------------ property
- (UIImageView *)revolveImageView{
    if (!_revolveImageView) {
        _revolveImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_iconMusic.jpeg"]]];
        [_revolveImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _revolveImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _revolveImageView.clipsToBounds  = YES;
        _revolveImageView.layer.cornerRadius = 130;
        _revolveImageView.layer.masksToBounds = YES;
        _revolveImageView.backgroundColor = [UIColor whiteColor];
    }
    return _revolveImageView;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_backImage.jpeg"]]];
        [_backImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
- (UILabel *)playTimeLabel{
    if (!_playTimeLabel) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.text = @"00:00:00";
        _playTimeLabel.textColor = [UIColor whiteColor];
        _playTimeLabel.textAlignment = NSTextAlignmentCenter;
        _playTimeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _playTimeLabel;
}
- (UILabel *)totalTimeLabel{
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:13];
        _totalTimeLabel.text = @"00:00:00";
        _totalTimeLabel.textColor = [UIColor whiteColor];
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
