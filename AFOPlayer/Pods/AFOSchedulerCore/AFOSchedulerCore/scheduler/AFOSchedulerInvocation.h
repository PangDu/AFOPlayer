//
//  AFOSchedulerInvocation.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/9.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AFOSCHEDULER_ERROR_CODES) {
    AFO_SCHEDULER_ERROR_CODES_NONE = 0,
    AFO_SCHEDULER_ERROR_CODES_SELECTOR_NULL,
    AFO_SCHEDULER_ERROR_CODES_SELECTOR_UNREALIZED,
    AFO_SCHEDULER_ERROR_CODES_TARGET_NULL,
    AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_SECESS,
    AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_NULL,
    AFO_SCHEDULER_ERROR_CODES_METHODSIGNATURE_ARGUMENTWROG
};

NS_ASSUME_NONNULL_BEGIN

@interface AFOSchedulerInvocation : NSObject
+ (instancetype)shareSchedulerCore;
- (nullable id)schedulerInstanceMethod:(SEL)method
                                target:(id)target
                                params:(NSArray *)params;
- (nullable id)schedulerClassMethod:(SEL)method
                                target:(char *)target
                                params:(NSArray *)params;
@end

NS_ASSUME_NONNULL_END
