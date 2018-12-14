//
//  AppDelegate+Initialization.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AppDelegate+Initialization.h"
#import "UIWindow+Initialization.h"
#import <AFOFFMpeg/AFOFFMpeg.h>
@implementation AppDelegate (Initialization)
#pragma mark ------------ 实例方法
#pragma mark ------ 初始化
- (void)windowInitialization:(AFOAppTabBarController *)tabBarController{
    self.window = [[AFOAppWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    tabBarController = [[AFOAppTabBarController alloc] init];
    [self.window tabBarInitialization:tabBarController];
    self.window.rootViewController = tabBarController;
    [[AFORouterManager shareInstance] settingRooterController:tabBarController];
    [self.window makeKeyAndVisible];
}
#pragma mark ------------ 类方法
@end
