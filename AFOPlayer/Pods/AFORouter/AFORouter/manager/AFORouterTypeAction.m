//
//  AFORouterTypeAction.m
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import "AFORouterTypeAction.h"

@implementation AFORouterTypeAction
#pragma mark ------------
- (void)addControllerAction:(UIViewController *)nextController
                    present:(UIViewController *)currentController
                 parameters:(NSDictionary *)parameters{
    ///------ 传递值
    if ([currentController respondsToSelector:@selector(didSenderRouterManagerDelegate)]) {
        self.valueModel = [currentController performSelector:@selector(didSenderRouterManagerDelegate)];
    }
    ///------ 获取值
    if ([nextController respondsToSelector:@selector(didReceiverRouterManagerDelegate:)]) {
        [nextController performSelector:@selector(didReceiverRouterManagerDelegate:) withObject:parameters];
    }
    ///------ 获取值
    if ([nextController respondsToSelector:@selector(didReceiverRouterManagerDelegate:parameters:)] && self.valueModel) {
        [nextController performSelector:@selector(didReceiverRouterManagerDelegate:parameters:) withObject:self.valueModel withObject:parameters];
    }
}
#pragma mark ------ 
- (void)currentController:(UIViewController *)current
           nextController:(UIViewController *)next
                parameter:(nonnull NSDictionary *)paramenter{
    
}
@end
