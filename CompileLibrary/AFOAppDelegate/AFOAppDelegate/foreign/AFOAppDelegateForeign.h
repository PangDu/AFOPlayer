//
//  AFOAppDelegateForeign.h
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AFOAppDelegateForeign : NSObject <UIApplicationDelegate>
+ (instancetype)shareInstance;
- (void)addImplementationTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
