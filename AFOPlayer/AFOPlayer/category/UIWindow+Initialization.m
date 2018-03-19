//
//  UIWindow+Initialization.m
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/31.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "UIWindow+Initialization.h"

@implementation UIWindow (Initialization)
#pragma mark ------
- (void)tabBarInitialization:(AFOAppTabBarController *)tabBarController{
    ///------ 首页
    AFOHPForeign *hp  = [[AFOHPForeign alloc] init];
    UIViewController *homePageController = [hp returnHPController];
    ///------ 列表
    AFOPlayListForeign *playList = [[AFOPlayListForeign alloc]init];
    UIViewController *playListController = [playList returnPlayListController];
    ///------ 设置
    AFOSettingForeign *setting = [[AFOSettingForeign alloc] init];
    UIViewController *settingController = [setting returnSettingController];
    [tabBarController setViewControllers:@[homePageController,playListController,settingController]];
}
@end
