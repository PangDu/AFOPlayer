//
//  AFOMediaForeignInterface+Array.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/10.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaForeignInterface+Array.h"

@implementation AFOMediaForeignInterface (Array)
- (void)getUnscreenshotsArray:(NSArray *)data
                      compare:(NSArray *)compare
                        block:(void (^)(NSArray *array))block {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",compare];
    //过滤数组
    NSArray *reslut = [data filteredArrayUsingPredicate:filterPredicate];
    block(reslut);
    NSLog(@"Reslut Filtered Array = %@",reslut);
}
@end
