//
//  TargetAFOHPListController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/22.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "TargetAFOHPListController.h"
#import "AFOHPListController.h"

@implementation TargetAFOHPListController
/**
 *  返回 NewsViewController 实例
 *
 *  @param params 要传给 NewsViewController 的参数
 */
- (UIViewController *)actionNativeToNewsViewController:(NSDictionary *)params {
    AFOHPListController *controller = [[AFOHPListController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    return controller;
}
@end
