//
//  AFOMediaErrorCodeManage.h
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/30.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOMediaErrorString.h"

@interface AFOMediaErrorCodeManager : NSObject

/**
 <#Description#>

 @param errorCode <#errorCode description#>
 @return <#return value description#>
 */
+ (NSError *)errorCode:(AFOPlayMediaErrorCode)errorCode;
@end
