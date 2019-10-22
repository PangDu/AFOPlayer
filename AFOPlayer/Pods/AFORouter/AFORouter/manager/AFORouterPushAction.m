//
//  AFORouterPushAction.m
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import "AFORouterPushAction.h"
@interface AFORouterPushAction ()

@end

@implementation AFORouterPushAction
#pragma mark ------ 
- (void)currentController:(UIViewController *)current
           nextController:(NSString *)next
                parameter:(nonnull NSDictionary *)paramenter{
    Class class = NSClassFromString(next);
    UIViewController *controller = [[class alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [AFOSchedulerBaseClass schedulerController:current present:controller parameters:paramenter];
    [current.navigationController pushViewController:controller animated:YES];
}
@end
