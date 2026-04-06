#import "UIViewController+HideTabBar.h"
#import <objc/runtime.h>

@implementation UIViewController (HideTabBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalMethod = class_getInstanceMethod([self class], @selector(viewWillAppear:));
        Method swizzledMethod = class_getInstanceMethod([self class], @selector(afo_viewWillAppear:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

- (void)afo_viewWillAppear:(BOOL)animated {
    [self afo_viewWillAppear:animated]; // 调用原始的 viewWillAppear:

    // 判断是否是需要隐藏TabBar的控制器
    if ([self isKindOfClass:NSClassFromString(@"AFOHPListController")] ||
        [self isKindOfClass:NSClassFromString(@"AFOHPDetailController")]) {
        self.hidesBottomBarWhenPushed = YES;
    } else {
        self.hidesBottomBarWhenPushed = NO;
    }
}

@end