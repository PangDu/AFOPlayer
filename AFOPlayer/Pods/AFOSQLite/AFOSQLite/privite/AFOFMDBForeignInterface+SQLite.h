//
//  AFOFMDBForeignInterface+SQLite.h
//  AFOSQLite
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <AFOSQLite/AFOSQLite.h>
@class FMDatabaseQueue;
@interface AFOFMDBForeignInterface (SQLite)
+ (BOOL)isTableHave:(NSString *)name dataBase:(FMDatabaseQueue *)dataBase;
@end
