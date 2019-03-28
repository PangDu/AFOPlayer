//
//  AFODelegateForeign.m
//  AFODelegateExtension
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFODelegateForeign.h"
#import <AFOGitHub/GCDMulticastDelegate.h>
@interface AFODelegateForeign ()
@property (nonatomic, strong)   GCDMulticastDelegate    *multicastDelegate;
@end
@implementation AFODelegateForeign
#pragma mark ------ shareInstance
+ (instancetype)shareInstance{
    static AFODelegateForeign *instance = nil;
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
    return self.multicastDelegate;
}
#pragma mark ------ setting target
- (void)addImplementationQueueTarget:(id)target{
    [self.multicastDelegate addDelegate:target delegateQueue:dispatch_get_main_queue()];
}
- (void)addImplementationQueueTarget:(id)target
                               queue:(dispatch_queue_t)queue{
    [self.multicastDelegate addDelegate:target delegateQueue:queue];
}
- (void)addImplementationArray:(NSArray *)array{
    [self addImplementationArray:array queue:dispatch_get_main_queue()];
}
- (void)addImplementationArray:(NSArray *)array
                         queue:(dispatch_queue_t)queue{
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addImplementationQueueTarget:obj queue:queue];
    }];
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
