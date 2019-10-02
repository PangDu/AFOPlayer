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
           nextController:(UIViewController *)next
                parameter:(nonnull NSDictionary *)paramenter{
    next.hidesBottomBarWhenPushed = YES;
    [self addControllerAction:next present:current parameters:paramenter];
    [current.navigationController pushViewController:next animated:YES];
}
@end
