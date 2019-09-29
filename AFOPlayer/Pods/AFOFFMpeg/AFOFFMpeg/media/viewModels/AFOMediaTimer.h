//
//  AFOMediaTimer.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOMediaTimer : NSObject
+ (NSInteger)yearDuration:(int64_t)douration;
+ (NSInteger)monthDurtaion:(int64_t)douration;
+ (NSInteger)dayDurtaion:(int64_t)douration;
+ (NSInteger)hourDuration:(int64_t)douration;
+ (NSInteger)minutesDuration:(int64_t)douration;
+ (NSInteger)secondsDuration:(int64_t)douration;
+ (NSInteger)totalSecondsDuration:(int64_t)douration;
+ (NSString *)timeFormatShort:(int64_t)douration;
+ (NSString *)currentTime:(int64_t)douration;
+ (NSInteger)totalNumberSeconds:(int64_t)douration;
@end
