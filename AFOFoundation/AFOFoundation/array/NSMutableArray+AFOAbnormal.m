//
//  NSMutableArray+AFOAbnormal.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSMutableArray+AFOAbnormal.h"

@implementation NSMutableArray (AFOAbnormal)
#pragma mark ------------ addObjectsFromArray
- (void)addObjectsFromArrayAFOAbnormal:(nonnull NSArray *)array{
    if (array != nil && array != NULL) {
        [self addObjectsFromArray:array];
    }
}
#pragma mark ------------ addObject
- (void)addObjectAFOAbnormal:(nonnull id)model{
    if (model != nil && model != NULL) {
        [self addObject:model];
    }
}
@end
