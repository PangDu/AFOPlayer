//
//  NSString+Formatting.m
//  AFOFoundation
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "NSString+Formatting.h"

@implementation NSString (Formatting)
#pragma mark ------ 时间转换成字符串
+ (NSString *)formatPlayTime:(NSTimeInterval)duration{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}
@end
