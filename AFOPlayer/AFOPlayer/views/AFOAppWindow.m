//
//  AFOAppWindow.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppWindow.h"

@interface AFOAppWindow ()
@property (nonnull, nonatomic, strong) AFOAppWindowViewModel *viewModel;
@end
@implementation AFOAppWindow
#pragma mark ------------ 自定义方法
- (void)tabBarInitialization:(AFOAppTabBarController *)tabBarController{
    [self.viewModel controllerInitialization:tabBarController];
}
#pragma mark ------------ property
- (AFOAppWindowViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AFOAppWindowViewModel alloc]init];
    }
    return _viewModel;
}
- (void)dealloc{
    NSLog(@"dealloc AFOAppWindow");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
