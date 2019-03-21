//
//  AFOAppDelegateForeign.m
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppDelegateForeign.h"
#import <AFOGitHub/GCDMulticastDelegate.h>
@interface AFOAppDelegateForeign ()
@property (nonatomic, strong)   GCDMulticastDelegate    *multicastDelegate;
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
    return self.multicastDelegate;
}
#pragma mark ------ setting target
- (void)addImplementationQueueTarget:(id<UIApplicationDelegate>)target
                               queue:(dispatch_queue_t)queue{
    [self.multicastDelegate addDelegate:target delegateQueue:queue];
}
#pragma mark ------ property
- (GCDMulticastDelegate *)multicastDelegate{
    if (!_multicastDelegate) {
        _multicastDelegate = (GCDMulticastDelegate <UIApplicationDelegate> *) [[GCDMulticastDelegate alloc] init];
    }
    return _multicastDelegate;
}
#pragma mark ------
- (void)dealloc{
    NSLog(@"AFOAppDelegateForeign dealloc");
}
@end
