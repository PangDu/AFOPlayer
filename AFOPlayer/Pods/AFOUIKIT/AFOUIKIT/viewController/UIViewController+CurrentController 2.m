//
//  UIViewController+CurrentController.m
//  AFOUIKit
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import "UIViewController+CurrentController.h"

@implementation UIViewController (CurrentController)
#pragma mark ------ 当前Controller
+ (UIViewController *)currentViewController {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentController = [self currentControllerFrom:controller];
    return currentController;
}
+ (UIViewController *)currentControllerFrom:(UIViewController *)controller{
    UIViewController *currentController;
    if ([controller presentedViewController]) {
        UIViewController *nextController = [controller presentedViewController];
        currentController = [self currentControllerFrom:nextController];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *nextController = [(UITabBarController *)controller selectedViewController];
        currentController = [self currentControllerFrom:nextController];
    } else if ([controller isKindOfClass:[UINavigationController class]]){
        UIViewController *nextController = [(UINavigationController *)controller visibleViewController];
        currentController = [self currentControllerFrom:nextController];
    } else {
        currentController = controller;
    }
    return currentController;
}
@end
