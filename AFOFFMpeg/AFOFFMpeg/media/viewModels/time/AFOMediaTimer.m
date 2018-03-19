//
//  AFOMediaTimer.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaTimer.h"
@implementation AFOMediaTimer
#pragma mark ------------
+ (NSInteger)microseconds:(int64_t)douration{
    return douration / 1000000;
}
#pragma mark ------------
+ (int64_t)timeFormicroseconds:(int64_t)douration{
    return douration * 1000000;
}
+ (NSInteger)yearDuration:(int64_t)douration{
    return 0;
}
+ (NSInteger)monthDurtaion:(int64_t)douration{
    return 0;
}
+ (NSInteger)dayDurtaion:(int64_t)douration{
    return 0;
}
#pragma mark ------------
+ (NSInteger)hourDuration:(int64_t)douration{;
    return [AFOMediaTimer microseconds:douration] / 3600;
}
#pragma mark ------------
+ (NSInteger)minutesDuration:(int64_t)douration{
    return ([AFOMediaTimer microseconds:douration] % 3600) / 60;
}
#pragma mark ------------
+ (NSInteger)secondsDuration:(int64_t)douration{
    return [AFOMediaTimer microseconds:douration] % 60;
}
#pragma mark ------------
+ (NSInteger)totalSecondsDuration:(int64_t)douration{
    return douration / 1000000;
}
#pragma mark ------------
+ (NSString *)timeFormatShort:(int64_t)douration{
    douration = [self timeFormicroseconds:douration];
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",[AFOMediaTimer hourDuration:douration],[AFOMediaTimer minutesDuration:douration],[AFOMediaTimer secondsDuration:douration]];
}
#pragma mark ------------
+ (NSString *)currentTime:(int64_t)douration{
    return [NSString stringWithFormat:@"%02lld:%02lld:%02lld",douration/ 3600,(douration % 3600) / 60, douration % 60];
}
- (void)dealloc{
    NSLog(@"dealloc AFOMediaTimer");
}
@end
