//
//  AFOSchedulerPassValueDelegate.h
//  AFOSchedulerCore
//
//  Created by piccolo on 2019/10/16.
//  Copyright © 2019 piccolo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFOSchedulerPassValueDelegate <NSObject>
@optional
- (id)schedulerSenderRouterManagerDelegate;
- (void)schedulerReceiverRouterManagerDelegate:(id)model;
- (void)schedulerReceiverRouterManagerDelegate:(id)model
                              parameters:(NSDictionary *)parameters;
- (void)schedulerReceiverRouterManagerDelegateArray:(NSArray *)array
                                   parameters:(NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
