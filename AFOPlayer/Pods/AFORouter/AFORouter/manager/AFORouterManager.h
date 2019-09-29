//
//  AFORouterManager.h
//  AFORouter
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AFORouterManager : NSObject

/**
 <#Description#>

 @return <#return value description#>
 */
+ (instancetype)shareInstance;

/**
 <#Description#>

 @param url <#url description#>
 @return <#return value description#>
 */
- (BOOL)routeURL:(NSURL *)url;

/**
 默认界面push切换

 @param controller pushViewController
 @return URL scheme
 */
- (NSString *)settingPushControllerRouter:(id)controller;

/**
 默认界面push切换传值

 @param controller pushViewController
 @param dictionary 传递的值
 @return URL scheme （含参）
 */
- (NSString *)settingPushControllerRouter:(id)controller
                                   params:(NSDictionary *)dictionary;

/**
 <#Description#>

 @param controller <#controller description#>
 @param present <#present description#>
 @param dictionary <#dictionary description#>
 @return <#return value description#>
 */
- (NSString *)settingPushControllerRouter:(id)controller
                                  present:(id)present
                                   params:(NSDictionary *)dictionary;
/**
 <#Description#>

 @param controller <#controller description#>
 */
- (void)settingRooterController:(id)controller;
@end
