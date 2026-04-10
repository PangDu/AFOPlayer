//
//  NSObject+AFOScheduler.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/9.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AFOScheduler)
- (nullable id)schedulerPerformSelector:(SEL)selector;
- (nullable id)schedulerPerformSelector:(SEL)selector
                                 params:(nullable NSArray *)params;
@end

NS_ASSUME_NONNULL_END
