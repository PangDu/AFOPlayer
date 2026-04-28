//
//  AFOAppTabBarController.m
//  AFOPlayer
//
//  Created by zhao yun on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAppTabBarController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface UINavigationController (AFOAutoHideTabBarSwizzle)
- (void)afo_autoHideTabBar_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

@implementation AFOAppTabBarController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class navClass = [UINavigationController class];
        SEL originalSEL = @selector(pushViewController:animated:);
        SEL swizzledSEL = @selector(afo_autoHideTabBar_pushViewController:animated:);

        Method original = class_getInstanceMethod(navClass, originalSEL);
        Method swizzled = class_getInstanceMethod(navClass, swizzledSEL);
        if (!original || !swizzled) {
            // 为了不引入额外文件依赖，这里动态添加实现。
            IMP swizzledIMP = imp_implementationWithBlock(^(__unsafe_unretained UINavigationController *selfNav,
                                                          UIViewController *vc,
                                                          BOOL animated) {
                BOOL isTabChildNav = (selfNav.tabBarController != nil);
                BOOL isPushingFromRoot = (selfNav.viewControllers.count > 0);
                if (isTabChildNav && isPushingFromRoot) {
                    NSString *name = NSStringFromClass([vc class]);
                    BOOL looksLikePlayer =
                    ([vc isKindOfClass:NSClassFromString(@"AVPlayerViewController")] ||
                     [name rangeOfString:@"Player" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                     [name rangeOfString:@"MediaPlay" options:NSCaseInsensitiveSearch].location != NSNotFound ||
                     [name hasSuffix:@"PlayController"] ||
                     [name hasSuffix:@"PlayerController"]);
                    if (looksLikePlayer) {
                        vc.hidesBottomBarWhenPushed = YES;
                    }
                }
                // 调用原始实现（交换后，swizzledSEL 指向原始 push）。
                ((void(*)(id, SEL, UIViewController *, BOOL))objc_msgSend)(selfNav, swizzledSEL, vc, animated);
            });
            const char *types = method_getTypeEncoding(original);
            class_addMethod(navClass, swizzledSEL, swizzledIMP, types);
            swizzled = class_getInstanceMethod(navClass, swizzledSEL);
        }
        if (original && swizzled) {
            method_exchangeImplementations(original, swizzled);
        }
    });
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
#if DEBUG
    NSLog(@"AFOAppTabBarController: viewDidLoad class=%@ viewControllers=%@ selected=%@",
          NSStringFromClass([self class]), self.viewControllers, self.selectedViewController);
#endif
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if DEBUG
    NSLog(@"AFOAppTabBarController: viewDidAppear viewControllers=%@ selected=%@", self.viewControllers, self.selectedViewController);
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#if DEBUG
    NSLog(@"AFOAppTabBarController: didReceiveMemoryWarning");
#endif
}

#pragma mark - 旋转

// 实际策略见 `AFOAppTabBarController+AFOAutoRotate`（由当前选中的子控制器决定）。

@end
