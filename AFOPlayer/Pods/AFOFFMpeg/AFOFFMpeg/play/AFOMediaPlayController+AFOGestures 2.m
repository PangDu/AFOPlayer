//
//  AFOMediaPlayController+AFOGestures.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaPlayController+AFOGestures.h"
#import <objc/runtime.h>
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
#import "AFOMediaView.h"

@interface AFOMediaPlayController ()<AFOMediaViewDelegate>
@property (nonatomic, strong) NSNumber *isShow;
@end

@implementation AFOMediaPlayController (AFOGestures)
#pragma mark ------------ property
- (void)setMediaView:(AFOMediaView *)mediaView{
    objc_setAssociatedObject(self, @selector(setMediaView:), mediaView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFOMediaView *)mediaView{
    return objc_getAssociatedObject(self, @selector(setMediaView:));
}
- (void)setIsShow:(NSNumber *)isShow{
    objc_setAssociatedObject(self, @selector(setIsShow:), isShow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)isShow{
    return objc_getAssociatedObject(self, @selector(setIsShow:));
}
#pragma mark ------
- (void)addMeidaView{
    if (!self.mediaView) {
        self.mediaView = [[AFOMediaView alloc] initWithFrame:self.view.frame delegate:self];
        [self.mediaView settingPlayButtonPause];
        [self.view addSubview:self.mediaView];
        ///------
        self.isShow = @(NO);
        [self.navigationController setNavigationBarHidden:[self.isShow boolValue] animated:YES];
    }
}
#pragma mark ------
- (void)settingMeidaViewImage:(UIImage *)image
                    totalTime:(NSString *)totalTime
                  currentTime:(NSString *)currentTime
                        total:(NSInteger)total
                      current:(NSInteger)current{
    [self.mediaView settingMovieImage:image
                            totalTime:totalTime
                          currentTime:currentTime
                                total:total
                              current:current];
}
#pragma mark ------ touchesBegan
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showOrHiddenNavigationBar];
}
- (void)showOrHiddenNavigationBar{
    WeakObject(self);
    [self.mediaView settingBottomViewShowOrHidden:^(UIView *view) {
        StrongObject(self);
        CGFloat offset = 0;
        if (![self.isShow boolValue]) {
            offset = view.frame.size.height + 5;
        }
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mediaView).offset(offset);
        }];
        [UIView animateWithDuration:.3 animations:^{
            [self.mediaView layoutIfNeeded];
            ///------
            [self.navigationController setNavigationBarHidden:![self.isShow boolValue] animated:YES];
        } completion:^(BOOL finished) {
            if ([self.isShow boolValue]) {
                self.isShow = @(NO);
            }else{
                self.isShow = @(YES);
            }
        }];
    }];
}
#pragma mark ------------ AFOMediaViewDelegate
- (void)buttonTouchActionDelegate:(BOOL)isSuspended{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaQueueManagerTimerNotifaction:" object:@(!isSuspended)];
}
@end
