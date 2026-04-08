//
//  AFOFMDBForeignInterface+SQLite.m
//  AFOSQLite
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOFMDBForeignInterface+SQLite.h"
#import <FMDB/FMDB.h>
@implementation AFOFMDBForeignInterface (SQLite)

#pragma mark ------------ 表是否存在
+ (BOOL)isTableHave:(NSString *)name dataBase:(FMDatabaseQueue *)dataBase{
    NSString *sql = [NSString stringWithFormat:@"select count(name) as countNum from sqlite_master where type = 'table' and name = '%@'", name ];
    __block BOOL result = NO;
    [dataBase inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        if ([resultSet next]) {
            NSInteger count = [resultSet intForColumn:@"countNum"];
            if (count == 1) {
                result = YES;
            }
        }
        [resultSet close];
    }];
    return result;
}
@end
