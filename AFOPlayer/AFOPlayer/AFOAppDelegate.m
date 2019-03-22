//
//  AFOAppDelegate.m
//  AFOPlayer
//
//  Created by xueguang xian on 2019/3/21.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppDelegate.h"
@interface AFOAppDelegate ()
@property (nonatomic, strong)   AFOAddControllerModel   *addModel;
@end
@implementation AFOAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.tabBarController;
    [[AFODelegateForeign shareInstance] addImplementationQueueTarget:(id<UIApplicationDelegate>)[AFORouterManager shareInstance]];
    [self.window makeKeyAndVisible];
    return [[AFODelegateForeign shareInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [[AFODelegateForeign shareInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return self.window.rootViewController.supportedInterfaceOrientations;
}
#pragma mark ------ property
- (AFOAddControllerModel *)addModel{
    if (!_addModel) {
        _addModel = [[AFOAddControllerModel alloc] init];
    }
    return _addModel;
}
- (AFOAppTabBarController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController = [[AFOAppTabBarController alloc] init];
        [self.addModel controllerInitialization:_tabBarController];
        [[AFORouterManager shareInstance] settingRooterController:self.tabBarController];
    }
    return _tabBarController;
}
@end
