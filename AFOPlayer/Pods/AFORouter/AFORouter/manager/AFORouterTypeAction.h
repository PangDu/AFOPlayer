//
//  AFORouterTypeAction.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFORouterTypeAction.h"
#import "AFORouterManagerDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@interface AFORouterTypeAction : NSObject<AFORouterManagerDelegate>
@property (nonatomic, strong)       id                   valueModel;
- (void)addControllerAction:(UIViewController *)pushController
                                         present:(UIViewController *)presentController
                                      parameters:(NSDictionary *)parameters;
- (void)currentController:(UIViewController *)current
           nextController:(UIViewController *)next
                parameter:(NSDictionary *)paramenter;
@end

NS_ASSUME_NONNULL_END
