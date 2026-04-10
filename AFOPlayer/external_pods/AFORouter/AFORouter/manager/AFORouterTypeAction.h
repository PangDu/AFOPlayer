//
//  AFORouterTypeAction.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFOSchedulerCore/AFOSchedulerBaseClass+AFORouter.h>
#import "AFORouterTypeAction.h"
NS_ASSUME_NONNULL_BEGIN
@interface AFORouterTypeAction : NSObject
- (void)currentController:(UIViewController *)current
           nextController:(NSString *)next
                parameter:(NSDictionary *)paramenter;
@end

NS_ASSUME_NONNULL_END
