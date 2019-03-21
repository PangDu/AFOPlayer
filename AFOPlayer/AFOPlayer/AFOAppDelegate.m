//
//  AFOAppDelegate.m
//  AFOPlayer
//
//  Created by xueguang xian on 2019/3/21.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppDelegate.h"

@implementation AFOAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self windowInitialization:self.tabBarController];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [[AFORouterManager shareInstance] routeURL:url];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return self.window.rootViewController.supportedInterfaceOrientations;
}
@end
