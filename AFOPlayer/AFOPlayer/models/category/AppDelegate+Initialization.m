//
//  AppDelegate+Initialization.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AppDelegate+Initialization.h"
#import "UIWindow+Initialization.h"
#import <AFOAppDelegateExtension/AFOAppDelegateHeader.h>
@implementation AppDelegate (Initialization)
#pragma mark ------------ Initialization
- (void)windowInitialization:(AFOAppTabBarController *)tabBarController{
    self.window = [[AFOAppWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    tabBarController = [[AFOAppTabBarController alloc] init];
    [self.window tabBarInitialization:tabBarController];
    self.window.rootViewController = tabBarController;
    [[AFORouterManager shareInstance] settingRooterController:tabBarController];
    [[AFOAppDelegateForeign shareInstance] addImplementationQueueTarget:(id<UIApplicationDelegate>)[AFORouterManager shareInstance] queue:dispatch_get_main_queue()];
    [self.window makeKeyAndVisible];
}
@end
