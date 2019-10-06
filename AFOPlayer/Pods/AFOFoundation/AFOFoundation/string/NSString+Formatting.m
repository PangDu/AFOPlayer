//
//  NSString+Formatting.m
//  AFOFoundation
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import "NSString+Formatting.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Formatting)
#pragma mark ------ 时间转换成字符串
+ (NSString *)formatPlayTime:(NSTimeInterval)duration{
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, secend];
}
#pragma mark ------------ 转化MD5
+ (NSString *)md5HexDigest:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
