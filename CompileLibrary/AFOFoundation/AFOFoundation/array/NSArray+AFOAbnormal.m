//
//  NSArray+AFOAbnormal.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSArray+AFOAbnormal.h"

@implementation NSArray (AFOAbnormal)
#pragma mark ------------ objectAtIndex
- (id)objectAtIndexAFOAbnormal:(NSInteger)index{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return [NSError errorWithDomain:@"objectAtIndex failure" code:-1 userInfo:NULL];
}
@end
