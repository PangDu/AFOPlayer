//
//  AFORouterActionContext.h
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface AFORouterActionContext : NSObject
- (void)passingCurrentController:(UIViewController *)current
                  nextController:(NSString *)next
                      parameters:(NSDictionary *)paramenter;
@end

NS_ASSUME_NONNULL_END
