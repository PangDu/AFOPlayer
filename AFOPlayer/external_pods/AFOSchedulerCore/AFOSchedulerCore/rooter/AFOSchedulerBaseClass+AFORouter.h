//
//  AFOSchedulerBaseClass+AFORouter.h
//  AFOSchedulerCore
//
//  Created by piccolo on 2019/10/15.
//  Copyright © 2019 piccolo. All rights reserved.
//

#import <AFOSchedulerCore/AFOSchedulerBaseClass.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AFOSchedulerBaseClass (AFORouter)
+ (void)schedulerRouterJumpPassingParameters:(NSDictionary *)parameters;
+ (void)schedulerController:(UIViewController *)currentController
                    present:(UIViewController *)nextController
                 parameters:(NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
