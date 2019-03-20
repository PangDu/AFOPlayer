//
//  TargetAFOHPListController.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/22.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetAFOHPListController : NSObject
/**
 *  返回 NewsViewController 实例
 *
 *  @param params 要传给 NewsViewController 的参数
 */
- (UIViewController *)actionNativeToNewsViewController:(NSDictionary *)params;
@end
