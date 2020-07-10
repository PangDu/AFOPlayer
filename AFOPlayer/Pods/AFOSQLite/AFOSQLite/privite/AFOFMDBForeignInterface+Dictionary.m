//
//  AFOFMDBForeignInterface+Dictionary.m
//  AFOSQLite
//
//  Created by xueguang xian on 2018/1/14.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOFMDBForeignInterface+Dictionary.h"

@implementation AFOFMDBForeignInterface (Dictionary)
#pragma mark ------------ 查询结果转化为model
+ (id)dictinaryToClassModel:(NSDictionary *)dictionary
                        model:(id)model{
    Class class = NSClassFromString(model);
    id object = [[class alloc] init];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [object setValue:obj forKey:key];
    }];
    return object;
}

@end
