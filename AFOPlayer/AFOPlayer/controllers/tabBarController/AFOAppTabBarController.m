//
//  AFOAppTabBarController.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppTabBarController.h"

@interface AFOAppTabBarController ()
@end

@implementation AFOAppTabBarController

#pragma mark ------------ 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"AFOAppTabBarController: viewDidLoad - self class: %@", NSStringFromClass([self class])); // 打印当前对象的类名
    // 显式调用 setup viewControllers
    AFOAddControllerModel *addModel = [[AFOAddControllerModel alloc] init];
    [addModel controllerInitialization:self];
    NSLog(@"AFOAppTabBarController: viewDidLoad - viewControllers: %@", self.viewControllers);
    NSLog(@"AFOAppTabBarController: viewDidLoad - selectedViewController: %@", self.selectedViewController);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; // 确保父类方法被调用
}
// 移除 viewDidAppear 中的 controllerInitialization，因为它会导致时机问题
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"AFOAppTabBarController: viewDidAppear - viewControllers: %@", self.viewControllers);
    NSLog(@"AFOAppTabBarController: viewDidAppear - selectedViewController: %@", self.selectedViewController);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ 是否可以旋转
- (BOOL)shouldAutorotate{
    return YES;
}
#pragma mark ------ 支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark ------------ 属性
@end
