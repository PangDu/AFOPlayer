//
//  AFOMediaForeignInterface+Dictionary.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/10.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaForeignInterface+Dictionary.h"

@implementation AFOMediaForeignInterface (Dictionary)
#pragma mark ------ vedioName
+ (NSString *)vedioName:(NSDictionary *)dic{
    if ([dic objectForKey:@"vedioName"]) {
        return [dic objectForKey:@"vedioName"];
    }
    return nil;
}
#pragma mark ------ imageName
+ (NSString *)imageName:(NSDictionary *)dic{
    if ([dic objectForKey:@"imageName"]) {
        return [dic objectForKey:@"imageName"];
    }
    return nil;
}
#pragma mark ------ width
+ (float)width:(NSDictionary *)dic{
    if ([dic objectForKey:@"width"]) {
        return [[dic objectForKey:@"width"] floatValue];
    }
    return 0;
}
#pragma mark ------ height
+ (float)height:(NSDictionary *)dic{
    if ([dic objectForKey:@"height"]) {
        return [[dic objectForKey:@"height"] floatValue];
    }
    return 0;
}
@end
