//
//  AFOAddControllerModel.m
//  AFOPlayer
//
//  Created by zhao yun on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppTabBarController.h"
#import <UIKit/UIKit.h>

@interface AFOAddControllerModel ()

@property (nullable, nonatomic, copy) NSArray<NSString *> *controllerArray;

@end

@implementation AFOAddControllerModel

#pragma mark - Public

- (void)controllerInitialization:(AFOAppTabBarController *)tabBarController {
    NSMutableArray<UIViewController *> *array = [NSMutableArray array];
    for (NSString *className in self.controllerArray) {
        Class cls = NSClassFromString(className);
        if (!cls) {
            continue;
        }
        id instance = [[cls alloc] init];
        UIViewController *root = [self rootViewControllerFromTabFactory:instance];
        if (root) {
            [array addObject:root];
        }
    }
    tabBarController.viewControllers = [array copy];
}

#pragma mark - Private

- (nullable UIViewController *)rootViewControllerFromTabFactory:(id)instance {
    UIViewController *show = nil;
    if ([instance respondsToSelector:@selector(returnController)]) {
        // 兼容未显式声明协议的模块（如外部 Pod）
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        show = [instance performSelector:@selector(returnController)];
#pragma clang diagnostic pop
    }
    if ([show isKindOfClass:[UIViewController class]]) {
        return show;
    }
    return nil;
}

#pragma mark - Properties

- (NSArray<NSString *> *)controllerArray {
    if (!_controllerArray) {
        _controllerArray = @[
            @"AFOPLMainController",
            @"AFOOPMainController"
        ];
    }
    return _controllerArray;
}

@end
