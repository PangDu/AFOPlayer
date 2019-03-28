//
//  AFOAppDelegateForeign.h
//  AFOAppDelegateExtension
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AFODelegateForeign : NSObject<UIApplicationDelegate>
+ (instancetype)shareInstance;
- (void)addImplementationQueueTarget:(id)target;
- (void)addImplementationQueueTarget:(id)target
                               queue:(dispatch_queue_t)queue;
- (void)addImplementationArray:(NSArray *)array;
- (void)addImplementationArray:(NSArray *)array
                         queue:(dispatch_queue_t)queue;

@end

NS_ASSUME_NONNULL_END
