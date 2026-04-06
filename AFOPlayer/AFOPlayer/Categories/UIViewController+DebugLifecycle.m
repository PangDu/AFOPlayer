#import "UIViewController+DebugLifecycle.h"
#import <objc/runtime.h>

@implementation UIViewController (DebugLifecycle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelectorWillAppear = @selector(viewWillAppear:);
        SEL swizzledSelectorWillAppear = @selector(dbg_viewWillAppear:);

        Method originalMethodWillAppear = class_getInstanceMethod(class, originalSelectorWillAppear);
        Method swizzledMethodWillAppear = class_getInstanceMethod(class, swizzledSelectorWillAppear);

        BOOL didAddMethodWillAppear = class_addMethod(class,
                                                      originalSelectorWillAppear,
                                                      method_getImplementation(swizzledMethodWillAppear),
                                                      method_getTypeEncoding(swizzledMethodWillAppear));

        if (didAddMethodWillAppear) {
            class_replaceMethod(class,
                                swizzledSelectorWillAppear,
                                method_getImplementation(originalMethodWillAppear),
                                method_getTypeEncoding(originalMethodWillAppear));
        } else {
            method_exchangeImplementations(originalMethodWillAppear, swizzledMethodWillAppear);
        }

        SEL originalSelectorWillDisappear = @selector(viewWillDisappear:);
        SEL swizzledSelectorWillDisappear = @selector(dbg_viewWillDisappear:);

        Method originalMethodWillDisappear = class_getInstanceMethod(class, originalSelectorWillDisappear);
        Method swizzledMethodWillDisappear = class_getInstanceMethod(class, swizzledSelectorWillDisappear);

        BOOL didAddMethodWillDisappear = class_addMethod(class,
                                                       originalSelectorWillDisappear,
                                                       method_getImplementation(swizzledMethodWillDisappear),
                                                       method_getTypeEncoding(swizzledMethodWillDisappear));

        if (didAddMethodWillDisappear) {
            class_replaceMethod(class,
                                swizzledSelectorWillDisappear,
                                method_getImplementation(originalMethodWillDisappear),
                                method_getTypeEncoding(originalMethodWillDisappear));
        } else {
            method_exchangeImplementations(originalMethodWillDisappear, swizzledMethodWillDisappear);
        }
    });
}

#pragma mark - Method Swizzling

- (void)dbg_viewWillAppear:(BOOL)animated {
    [self dbg_viewWillAppear:animated];
    NSLog(@"[DebugLifecycle] viewWillAppear: %@ (Address: %p)", NSStringFromClass([self class]), self);
    // 这里暂时不进行 TabBar 的隐藏操作，只关注日志输出
}

- (void)dbg_viewWillDisappear:(BOOL)animated {
    [self dbg_viewWillDisappear:animated];
    NSLog(@"[DebugLifecycle] viewWillDisappear: %@ (Address: %p)", NSStringFromClass([self class]), self);
    // 这里暂时不进行 TabBar 的显示操作，只关注日志输出
}

@end