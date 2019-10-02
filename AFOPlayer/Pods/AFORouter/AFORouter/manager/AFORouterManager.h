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
@end
