//
//  AFOMediator+AFOHPListController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/22.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMediator+AFOHPListController.h"
//  1. 字符串 是类名 Target_xxx.h 中的 xxx 部分
NSString * const AFOMediatorTargetHPListController = @"AFOHPListController";
//  2. 字符串是 Target_xxx.h 中 定义的 action_xxxx 函数名的 xxx 部分
NSString * const AFOMediatorActionHPListControllerNewsViewController = @"NativeToNewsViewController";
@implementation AFOMediator (AFOHPListController)
- (UIViewController *)afoHPListControllerMediatorNewsViewControllerWithParams:(NSDictionary *)dictionary {
    
    UIViewController *viewController = [self performTarget:AFOMediatorTargetHPListController
                                                    action:AFOMediatorActionHPListControllerNewsViewController
                                                    params:dictionary];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        NSLog(@"%@ 未能实例化页面", NSStringFromSelector(_cmd));
        return [[UIViewController alloc] init];
    }
}
@end
