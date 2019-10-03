//
//  AFORouterActionContext.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface AFORouterActionContext : NSObject
- (instancetype)initAction:(NSString *)strAction;
- (void)currentController:(UIViewController *)current
           nextController:(UIViewController *)next
                parameter:(NSDictionary *)paramenter;
@end

NS_ASSUME_NONNULL_END
