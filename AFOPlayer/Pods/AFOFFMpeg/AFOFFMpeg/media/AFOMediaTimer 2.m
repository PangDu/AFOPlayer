//
//  AFOMediaTimer.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaTimer.h"
#import <libswresample/swresample.h>
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
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[AFOMediaTimer hourDuration:douration],(long)[AFOMediaTimer minutesDuration:douration],(long)[AFOMediaTimer secondsDuration:douration]];
}
#pragma mark ------------
+ (NSString *)currentTime:(int64_t)douration{
    return [NSString stringWithFormat:@"%02lld:%02lld:%02lld",douration/ 3600,(douration % 3600) / 60, douration % 60];
}
#pragma mark ------
+ (NSInteger)totalNumberSeconds:(int64_t)douration{
    NSInteger total = 0;
    if(douration != AV_NOPTS_VALUE){
        NSInteger hours, mins, secs, us;
        int64_t duration = douration + 5000;
        secs = duration / AV_TIME_BASE;
        us = duration % AV_TIME_BASE;
        mins = secs / 60;
        secs %= 60;
        hours = mins/ 60;
        mins %= 60;
        total = hours * 3600 + mins *60 + secs;
    }
    return total;
}
- (void)dealloc{
    NSLog(@"dealloc AFOMediaTimer");
}
@end
