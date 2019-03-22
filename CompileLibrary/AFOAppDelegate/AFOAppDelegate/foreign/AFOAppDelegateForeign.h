//
//  AFOAppDelegateForeign.h
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFOAppDelegateProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface AFOAppDelegateForeign : NSObject <UIApplicationDelegate>
+ (instancetype)shareInstance;
- (void)addImplementationArray:(NSArray *)array
                         queue:(dispatch_queue_t)queue;
- (void)addImplementationQueueTarget:(id)target
                               queue:(dispatch_queue_t)queue;
@end

NS_ASSUME_NONNULL_END
