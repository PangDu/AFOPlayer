//
//  AFORouterManager.m
//  AFORouter
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFORouterManager.h"
#import <UIKit/UIKit.h>
#import "JLRoutes.h"
#import "AFORouterManager+StringManipulation.h"
#import "AFORouterInfoplist.h"
#import "AFORouterManagerDelegate.h"

@interface AFORouterManager ()<AFORouterManagerDelegate,UIApplicationDelegate>
@property (nonatomic, strong) JLRoutes                  *routes;
@property (nonatomic, copy)   NSString                  *strScheme;
@property (nonatomic, strong)       id                   rootController;
@property (nonatomic, strong)       id                   valueModel;
@end

@implementation AFORouterManager
#pragma mark ------ shareInstance
+ (instancetype)shareInstance{
    static AFORouterManager<UIApplicationDelegate> *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}
#pragma mark ------
+ (void)initialize{
    if (self == [AFORouterManager class]) {
        [self loadNotification];
    }
}
#pragma mark ------
+ (void)loadNotification{
    [[AFORouterManager shareInstance] readRouterScheme];
    [[AFORouterManager shareInstance] loadRotesFile];
}
#pragma mark ------ 获取RooterController
- (void)settingRooterController:(id)controller{
    self.rootController = controller;
}
#pragma mark ------ 设置Schemes
- (void)readRouterScheme{
    self.strScheme = [AFORouterInfoplist readAppInfoPlistFile];
    _routes = [JLRoutes routesForScheme:self.strScheme];
}
#pragma mark ------ 添加跳转规则
- (void)loadRotesFile{
    __weak typeof(self) weakSelf = self;
    [self.routes addRoute:@"/push/:presentController/:pushController"handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        ///------
        Class classPush = NSClassFromString(parameters[@"pushController"]);
        UIViewController *nextController = [[classPush alloc] init];
        nextController.hidesBottomBarWhenPushed = YES;
        UIViewController *currentController = [weakSelf currentViewController];
        [weakSelf addSenderControllerRouterManagerDelegate:nextController present:currentController parameters:parameters];
        [currentController.navigationController pushViewController:nextController animated:YES];
        return YES;
    }];
}
#pragma mark ------------
- (void)addSenderControllerRouterManagerDelegate:(id)pushController
                                         present:(id)presentController
                                      parameters:(NSDictionary *)parameters{
    ///------ 传递值
    if ([presentController respondsToSelector:@selector(didSenderRouterManagerDelegate)]) {
        self.valueModel = [presentController performSelector:@selector(didSenderRouterManagerDelegate)];
    }
    ///------ 获取值
    if ([pushController respondsToSelector:@selector(didReceiverRouterManagerDelegate:)]) {
        [pushController performSelector:@selector(didReceiverRouterManagerDelegate:) withObject:parameters];
    }
    ///------ 获取值
    if ([pushController respondsToSelector:@selector(didReceiverRouterManagerDelegate:parameters:)] && self.valueModel) {
        [pushController performSelector:@selector(didReceiverRouterManagerDelegate:parameters:) withObject:self.valueModel withObject:parameters];
    }
}
#pragma mark ------ 当前Controller
- (UIViewController *)currentViewController{
    if ([self.rootController isKindOfClass:[UINavigationController class]]) {
        return [self returnNavigationLastObject:self.rootController];
    }else if ([self.rootController isKindOfClass:[UITabBarController class]]){
        return [self returnTabBarControllerSelect:self.rootController];
    }
    return self.rootController;
}
#pragma mark ------ navigation last Controller
- (id)returnNavigationLastObject:(id)controller{
    UINavigationController  *navigation = (UINavigationController *)controller;
    return [[navigation viewControllers] lastObject];
}
#pragma mark ------ tabBarController select Controller
- (id)returnTabBarControllerSelect:(id)controller{
    UITabBarController *tabBar = controller;
    if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [self returnNavigationLastObject:tabBar.selectedViewController];
    }else{
        return tabBar.selectedViewController;
    }
}
#pragma mark ------ 匹配URL
- (BOOL)routeURL:(NSURL *)url{
    return [self.routes routeURL:url];
}
#pragma mark ------ 不带参数URL
- (NSString *)settingPushControllerRouter:(id)controller{
    return [self settingPushControllerRouter:controller scheme:self.strScheme params:nil];
}
#pragma mark ------ 带参数URL
- (NSString *)settingPushControllerRouter:(id)controller params:(NSDictionary *)dictionary{
    return [self settingPushControllerRouter:controller scheme:self.strScheme params:dictionary];
}
#pragma mark ------
- (NSString *)settingPushControllerRouter:(id)controller
                                  present:(id)present
                                   params:(NSDictionary *)dictionary{
    return [self settingPushControllerRouter:controller present:present scheme:self.strScheme params:dictionary];
}
#pragma mark ------ UIApplicationDelegate
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [self routeURL:url];
}
#pragma mark ------ dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark ------ property
- (UIViewController *)rootController{
    if (!_rootController) {
        _rootController = [[UIViewController alloc]init];
    }
    return _rootController;
}
@end
