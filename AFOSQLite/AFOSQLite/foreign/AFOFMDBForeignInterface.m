//
//  AFOFMDBForeignInterface.m
//  AFOFMDB
//
//  Created by xueguang xian on 2018/1/11.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOFMDBForeignInterface.h"
#import "AFOFMDBForeignInterface+SQLite.h"
#import "AFOFMDBForeignInterface+Dictionary.h"
#import "FMDB.h"

@interface AFOFMDBForeignInterface ()
@property (nonatomic, strong) FMDatabaseQueue *queue;
@end
@implementation AFOFMDBForeignInterface
#pragma mark ------------
+ (instancetype)shareInstance{
    static AFOFMDBForeignInterface *shareInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
#pragma mark ------------ create statements
+ (void)createSQLiteTable:(NSString *)table
                     path:(NSString *)path
               statements:(NSString *)statements
                    block:(void (^)(BOOL isSucessed))block{
    [AFOFMDBForeignInterface shareInstance].queue = [FMDatabaseQueue databaseQueueWithPath:path];
    ///--- 创建表
    BOOL isHave = [self isTableHave:table dataBase:[AFOFMDBForeignInterface shareInstance].queue];
    if (!isHave) {
        __block BOOL result;
        [[AFOFMDBForeignInterface shareInstance].queue inDatabase:^(FMDatabase * _Nonnull db) {
          result = [db executeUpdate:statements];
        }];
        block(result);
    }else{
        block(NO);
    }
}
#pragma mark ------------ insert statements
+ (void)insertSQLiteTableStatements:(NSString *)statements
                              block:(void (^)(BOOL isSucessed))block{
    [[AFOFMDBForeignInterface shareInstance].queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:statements];
        block(result);
    }];
}
#pragma mark ------------ select statements
+ (void)selectSQLiteTableStatements:(NSString *)statements
                              model:(id)model
                              block:(void (^)(NSArray *array))block{
    __block NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    __weak __typeof(self) weakSelf = self;
    [[AFOFMDBForeignInterface shareInstance].queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:statements];
        while ([result next]) {
         NSDictionary *keyDic = [result resultDictionary];
          id obj = [weakSelf dictinaryToClassModel:keyDic model:model];
         [dataArray addObject:obj];
        }
    }];
    if (dataArray.count > 0) {
        block(dataArray);
    }else{
        block(NULL);
    }
}
#pragma mark ------ delete data
+ (void)deleteSQLiteTableStatements:(NSString *)statements
                              block:(void (^)(BOOL isSucess))block{
    [[AFOFMDBForeignInterface shareInstance].queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:statements];
        block(result);
    }];
}
+ (void)deleteTransactionStatements:(NSArray<NSString *> *)array
                              block:(void (^)(BOOL isSucess))block{
    [[AFOFMDBForeignInterface shareInstance].queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isResult = [db executeUpdate:obj];
            if (!isResult) {
                *rollback = YES;
                return;
            }
        }];
        block(!*rollback);
    }];
}
@end
