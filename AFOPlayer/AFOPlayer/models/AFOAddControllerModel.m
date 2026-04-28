//
//  AFOAddControllerModel.m
//  AFOPlayer
//
//  Created by zhao yun on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppTabBarController.h"
#import <UIKit/UIKit.h>
#import <AFOPlaylist/AFOPlayListForeign.h>
#import <AFOOnlinePlay/AFOOPMainController.h>

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
        /// Tab 子模块必须用各自对外的「工厂」类：需实现 `-returnController`。
        /// 播放列表在 `AFOPlayListForeign` 中封装导航栈；`AFOPLMainController` 无该方法，会导致该 Tab 被跳过。
        _controllerArray = @[
            NSStringFromClass([AFOPlayListForeign class]),
            NSStringFromClass([AFOOPMainController class])
        ];
    }
    return _controllerArray;
}

@end
