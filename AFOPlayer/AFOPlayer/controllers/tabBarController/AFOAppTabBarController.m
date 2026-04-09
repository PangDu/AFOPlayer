//
//  AFOAppTabBarController.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppTabBarController.h"

@implementation AFOAppTabBarController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
#if DEBUG
    NSLog(@"AFOAppTabBarController: viewDidLoad class=%@ viewControllers=%@ selected=%@",
          NSStringFromClass([self class]), self.viewControllers, self.selectedViewController);
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if DEBUG
    NSLog(@"AFOAppTabBarController: viewDidAppear viewControllers=%@ selected=%@", self.viewControllers, self.selectedViewController);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 旋转

// 实际策略见 `AFOAppTabBarController+AFOAutoRotate`（由当前选中的子控制器决定）。

@end
