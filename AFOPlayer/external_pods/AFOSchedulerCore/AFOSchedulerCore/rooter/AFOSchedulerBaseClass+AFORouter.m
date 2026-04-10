//
//  AFOSchedulerBaseClass+AFORouter.m
//  AFOSchedulerCore
//
//  Created by piccolo on 2019/10/15.
//  Copyright © 2019 piccolo. All rights reserved.
//

#import "AFOSchedulerBaseClass+AFORouter.h"
#import <AFOSchedulerCore/AFOSchedulerPassValueDelegate.h>
@interface AFOSchedulerBaseClass ()<AFOSchedulerPassValueDelegate>

@end

@implementation AFOSchedulerBaseClass (AFORouter)
#pragma mark ------ router
+ (void)schedulerRouterJumpPassingParameters:(NSDictionary *)parameters{
    SEL current = NSSelectorFromString(@"currentViewController");
    if ([UIViewController respondsToSelector:current]) {
        id controller = [UIViewController performSelector:current];
        NSArray *paraArray = @[controller,parameters[@"next"],parameters];
        Class class = NSClassFromString(@"AFORouterActionContext");
        id instance = [[class alloc] init];
        SEL sel = NSSelectorFromString(@"passingCurrentController:nextController:parameters:");
        if ([instance respondsToSelector:sel]) {
            [instance schedulerPerformSelector:sel params:paraArray];
        }
    }
}
#pragma mark ------------
+ (void)schedulerController:(UIViewController *)currentController
                    present:(UIViewController *)nextController
                 parameters:(NSDictionary *)parameters{
    id valueModel;
    ///------ 传递值
    if ([currentController respondsToSelector:@selector(schedulerSenderRouterManagerDelegate)]) {
        valueModel = [currentController performSelector:@selector(schedulerSenderRouterManagerDelegate)];
    }
    ///------ 获取值
    if ([nextController respondsToSelector:@selector(schedulerReceiverRouterManagerDelegate:)]) {
        [nextController performSelector:@selector(schedulerReceiverRouterManagerDelegate:) withObject:parameters];
    }
    ///------ 获取值
    if ([nextController respondsToSelector:@selector(schedulerReceiverRouterManagerDelegate:parameters:)] && valueModel) {
        [nextController performSelector:@selector(schedulerReceiverRouterManagerDelegate:parameters:) withObject:valueModel withObject:parameters];
    }
}
@end
