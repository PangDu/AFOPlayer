//
//  AFOAppDelegateHook.m
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppDelegateHook.h"
@interface AFOAppDelegateHook()
@end
@implementation AFOAppDelegateHook
#pragma mark - launching
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [_delegate application:application willFinishLaunchingWithOptions:launchOptions];
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [_delegate application:application didFinishLaunchingWithOptions:launchOptions];
    NSLog(@"Thread name ====== %@",[NSThread currentThread]);
    NSLog(@"didFinishLaunching ====== %@",NSStringFromClass([self class]));
    return YES;
}
#pragma mark - State Transitions / Transitioning to the foreground:
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [_delegate applicationDidBecomeActive:application];
}
#pragma mark - State Transitions / Transitioning to the foreground:
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [_delegate applicationDidEnterBackground:application];
}
#pragma mark - State Transitions / Transitioning to the inactive state:
- (void)applicationWillResignActive:(UIApplication *)application{
    [_delegate applicationWillResignActive:application];
}
// Called when transitioning out of the background state.
- (void)applicationWillEnterForeground:(UIApplication *)application{
    [_delegate applicationWillEnterForeground:application];
}
#pragma mark - State Transitions / Termination:
- (void)applicationWillTerminate:(UIApplication *)application{
    [_delegate applicationWillTerminate:application];
}

#pragma mark - Handling Remote Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [_delegate application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [_delegate application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    [_delegate application:application
didReceiveRemoteNotification:userInfo
    fetchCompletionHandler:completionHandler];
}

// Deprecated from iOS 10.0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [_delegate application:application didReceiveRemoteNotification:userInfo];
}
//#pragma mark - Handling Local Notification
//#ifdef __IPHONE_10_0
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//       willPresentNotification:(UNNotification *)notification
//         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//}
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center
//didReceiveNotificationResponse:(UNNotificationResponse *)response
//         withCompletionHandler:(void (^)(void))completionHandler{
//}
//#endif
// Deprecated from iOS 10.0
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [_delegate application:application didReceiveLocalNotification:notification];
}
#pragma mark ------ 当用户从远程通知中选择操作激活应用程序时调用
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
   withResponseInfo:(NSDictionary *)responseInfo
  completionHandler:(void (^)(void))completionHandler{
}
#pragma mark - Handling Continuing User Activity and Handling Quick Actions
- (BOOL)application:(UIApplication *)application
willContinueUserActivityWithType:(NSString *)userActivityType{
    return NO;
}
- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler{
    return NO;
}
- (void)application:(UIApplication *)application
didUpdateUserActivity:(NSUserActivity *)userActivity{
    [_delegate application:application
     didUpdateUserActivity:userActivity];
}

- (void)application:(UIApplication *)application
didFailToContinueUserActivityWithType:(NSString *)userActivityType
              error:(NSError *)error{
    [_delegate application:application
didFailToContinueUserActivityWithType:userActivityType
                     error:error];
}
//#pragma mark ------ 9.0 当用户在主屏幕上选择快捷方式激活应用程序时调用
//#ifdef __IPHONE_9_0
//- (void)application:(UIApplication *)application
//performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
//  completionHandler:(void (^)(BOOL succeeded))completionHandler{
//}
//#endif
#pragma mark ------ property
- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
- (NSMutableArray *)targetArray{
    if (!_targetArray) {
        _targetArray = [[NSMutableArray alloc] init];
    }
    return _targetArray;
}
@end
