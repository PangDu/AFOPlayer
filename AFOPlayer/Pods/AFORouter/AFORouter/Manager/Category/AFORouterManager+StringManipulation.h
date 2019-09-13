//
//  AFORouterManager+StringManipulation.h
//  AFORouter
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <AFORouter/AFORouter.h>

@interface AFORouterManager (StringManipulation)

/**
 <#Description#>

 @param url <#url description#>
 @param params <#params description#>
 @return <#return value description#>
 */
- (NSString*)addQueryStringToUrl:(NSString *)url
                          params:(NSDictionary *)params;


/**
 <#Description#>

 @param controller <#controller description#>
 @param scheme <#scheme description#>
 @param dictionary <#dictionary description#>
 @return <#return value description#>
 */
- (NSString *)settingPushControllerRouter:(id)controller
                                   scheme:(NSString *)scheme
                                   params:(NSDictionary *)dictionary;

/**
 <#Description#>

 @param controller <#controller description#>
 @param present <#present description#>
 @param scheme <#scheme description#>
 @param dictionary <#dictionary description#>
 @return <#return value description#>
 */
- (NSString *)settingPushControllerRouter:(id)controller
                                  present:(id)present
                                   scheme:(NSString *)scheme
                                   params:(NSDictionary *)dictionary;
@end
