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
    NSString *title = nil;
    id rawTitle = paramenter[@"title"];
    if ([rawTitle isKindOfClass:[NSString class]]) {
        title = (NSString *)rawTitle;
    }
    if (title.length > 0) {
        controller.title = title;
        controller.navigationItem.title = title;
        if (@available(iOS 11.0, *)) {
            controller.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
        }
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [titleLabel sizeToFit];
        controller.navigationItem.titleView = titleLabel;
    }
    [AFOSchedulerBaseClass schedulerController:current present:controller parameters:paramenter];
    // 兼容 current 不是可见控制器导致 navigationController 为空的情况
    UINavigationController *nav = current.navigationController ?: current.tabBarController.selectedViewController.navigationController;
    if (nav) {
        nav.navigationBar.hidden = NO;
        nav.navigationBar.alpha = 1.0;
        nav.navigationBar.translucent = NO;
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = nav.navigationBar.standardAppearance ?: [[UINavigationBarAppearance alloc] init];
            [appearance configureWithOpaqueBackground];
            appearance.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
            appearance.largeTitleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
            nav.navigationBar.standardAppearance = appearance;
            nav.navigationBar.scrollEdgeAppearance = appearance;
            nav.navigationBar.compactAppearance = appearance;
        } else {
            nav.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
        }
    }
    [nav pushViewController:controller animated:YES];
}
@end
