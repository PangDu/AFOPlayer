//
//  AFOHPPlayerBaseView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol AFOHPAVPlayerViewDelegate
@optional
- (void)playMusicActionDelegate:(BOOL)isPlay;
@end
@interface AFOHPPlayerBaseView : UIView
@property (nonatomic, strong) UIImageView               *revolveImageView;
@property (nonatomic, strong) UIImageView               *backImageView;
@property (nonatomic, strong) UILabel                   *playTimeLabel;
@property (nonatomic, strong) UILabel                   *totalTimeLabel;
@property (nonatomic, strong) UIButton                  *onButton;
@property (nonatomic, strong) UIButton                  *playButton;
@property (nonatomic, strong) UIButton                  *nextButton;
- (void)playMusicAction:(UIButton *)sender;
- (void)changeButtonImage:(UIButton *)sender;
- (void)changeMusicAction:(UIButton *)sender;
- (void)settingDefaultTimer;
@end

NS_ASSUME_NONNULL_END
