//
//  AFOAppDelegateForeign.m
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppDelegateForeign.h"
#import "AFOAppDelegateHook.h"
#import <AFOGitHub/GCDMulticastDelegate.h>
@interface AFOAppDelegateForeign ()<AFOAppDelegateHookDelegate>
@property (nonatomic, strong)   AFOAppDelegateHook  *hook;
@end
@implementation AFOAppDelegateForeign
#pragma mark ------ shareInstance
+ (instancetype)shareInstance{
    static AFOAppDelegateForeign *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
#pragma mark ------ message forward
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return self;
    }
    return self.hook;
}
#pragma mark ------ setting target
- (void)addImplementationTarget:(id)target{
    NSLog(@"Thread name ====== %@",[NSThread currentThread]);
    NSLog(@"target name ===== %@",NSStringFromClass([target class]));
}
#pragma mark ------ property
- (AFOAppDelegateHook *)hook{
    if (!_hook) {
        _hook = [[AFOAppDelegateHook alloc] init];
    }
    return _hook;
}
#pragma mark ------
- (void)dealloc{
    NSLog(@"AFOAppDelegateForeign dealloc");
}
@end
