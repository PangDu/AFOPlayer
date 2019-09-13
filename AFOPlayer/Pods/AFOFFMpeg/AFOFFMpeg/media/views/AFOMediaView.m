//
//  AFOMediaView.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/28.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMediaView.h"
#import "AFOMediaControlView.h"
@interface AFOMediaView ()<AFOMediaControlViewDelegate>
@property (nonnull,nonatomic, strong) UIImageView           *playImageView;
@property (nonnull,nonatomic, strong) AFOMediaControlView   *controlView;
@property (nonatomic, weak) id<AFOMediaViewDelegate> delegate;
@end
@implementation AFOMediaView

#pragma mark ----------- init
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate{
    if (self = [super initWithFrame:frame]){
        _delegate = delegate;
        [self viewAddSubViews:frame];
    }
    return self;
}
#pragma mark ------------ custom
- (void)viewAddSubViews:(CGRect)frame{
    ///------ 显示
    self.playImageView.frame = frame;
    [self addSubview:self.playImageView];
    ///------
    [self addSubview:self.controlView];
    ///------
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(80);
        make.bottom.equalTo(self);
    }];
}
#pragma mark ------ 设置图片
- (void)settingMovieImage:(UIImage *)image
                totalTime:(NSString *)totalTime
              currentTime:(NSString *)currentTime
                    total:(NSInteger)total
                  current:(NSInteger)current{
    WeakObject(self);
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        StrongObject(self);
        [self.controlView settingTime:totalTime currentTime:currentTime total:total current:current block:^(BOOL isEnd) {
        }];
        if (image) {
            self.playImageView.image = image;
        }
    }];
}
#pragma mark ------ 设置播放按钮暂定图片
- (void)settingPlayButtonPause{
    [self.controlView settingPlayButtonPause];
}
#pragma mark ------
- (void)settingBottomViewShowOrHidden:(void (^)(UIView *view))block{
    block(self.controlView);
}
#pragma mark ------------ AFOMediaControlViewDelegate
- (void)buttonTouchActionDelegate:(BOOL)isSuspended{
   [self.delegate buttonTouchActionDelegate:isSuspended];
}
#pragma mark ------------ property
#pragma mark ------ playImageView
- (UIImageView *)playImageView{
    if (!_playImageView){
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _playImageView;
}
#pragma mark ------ controlView
- (AFOMediaControlView *)controlView{
    if (!_controlView) {
        _controlView = [[AFOMediaControlView alloc] initWithFrame:CGRectZero delegate:self];
    }
    return _controlView;
}
- (void)dealloc{
    NSLog(@"dealloc AFOMediaView");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
