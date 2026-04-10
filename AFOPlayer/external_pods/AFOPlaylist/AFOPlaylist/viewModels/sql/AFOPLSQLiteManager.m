//
//  AFOPlaylistSQLiteManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLSQLiteManager.h"
#import <AFOSQLite/AFOSQLite.h>
#import <FMDB/FMDB.h>
#import "AFOPLThumbnail.h"

static FMDatabaseQueue *AFOPLForeignDatabaseQueue(void) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id api = [AFOFMDBForeignInterface performSelector:@selector(shareInstance)];
#pragma clang diagnostic pop
    return [api valueForKey:@"queue"];
}

static BOOL AFOPLIsValidSQLTableName(NSString *name) {
    if (name.length == 0 || name.length > 128) {
        return NO;
    }
    NSCharacterSet *alnum = [NSCharacterSet alphanumericCharacterSet];
    for (NSUInteger i = 0; i < name.length; i++) {
        unichar c = [name characterAtIndex:i];
        if (c != '_' && ![alnum characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

/// 将已通过校验的表名转为 SQLite 双引号标识符。
static NSString *AFOPLQuoteSQLTableName(NSString *name) {
    if (!AFOPLIsValidSQLTableName(name)) {
        return nil;
    }
    return [NSString stringWithFormat:@"\"%@\"", name];
}

@implementation AFOPLSQLiteManager
#pragma mark ------------ 创建表
+ (NSString *)createTable:(NSString *)name{
    NSString *qTable = AFOPLQuoteSQLTableName(name);
    if (!qTable) {
        return nil;
    }
    return [NSString stringWithFormat:
            @"CREATE TABLE IF NOT EXISTS %@ ("
            "\"vedio_id\" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            "\"vedio_name\" VARCHAR(255),"
            "\"image_name\" VARCHAR(255),"
            "\"create_time\" VARCHAR(255),"
            "\"image_width\" INTEGER,"
            "\"image_hight\" INTEGER"
            ")", qTable];
}
#pragma mark ------------ 创建数据库
+ (void)createSQLiteDataBase:(NSString *)dataBase
                        path:(NSString *)path
                       block:(void (^)(BOOL isFinish))block{
    NSString *statements = [self createTable:dataBase];
    if (!statements.length) {
        block(NO);
        return;
    }
    [AFOFMDBForeignInterface createSQLiteTable:dataBase path:path statements:statements block:^(BOOL isSucessed) {
        block(isSucessed);
    }];
}
#pragma mark ------------ 插入数据
+ (void)inserSQLiteDataBase:(NSString *)dataBase
                     isHave:(BOOL)isHave
                 createTime:(NSString *)createTime
                  vedioName:(NSString *)vedioName
                  imageName:(NSString *)imageName
                      width:(int)width
                     height:(int)height
                      block:(void (^) (BOOL isFinish))block{
    if (!isHave) {
        block(NO);
        return;
    }
    NSString *qTable = AFOPLQuoteSQLTableName(dataBase);
    if (!qTable) {
        block(NO);
        return;
    }
    NSString *sql = [NSString stringWithFormat:
                     @"INSERT INTO %@ (vedio_name, image_name, create_time, image_width, image_hight) "
                     @"VALUES (?, ?, ?, ?, ?)", qTable];
    NSArray *values = @[
        vedioName ?: @"",
        imageName ?: @"",
        createTime ?: @"",
        @(width),
        @(height)
    ];
    FMDatabaseQueue *queue = AFOPLForeignDatabaseQueue();
    if (!queue) {
        block(NO);
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        BOOL ok = [db executeUpdate:sql values:values error:NULL];
        block(ok);
    }];
}
#pragma mark ------------ 查询语句
+ (NSString *)selectTable:(NSString *)table{
    NSString *qTable = AFOPLQuoteSQLTableName(table);
    if (!qTable) {
        return nil;
    }
    return [NSString stringWithFormat:@"SELECT * FROM %@", qTable];
}
#pragma mark ------------ 查询数据
+ (void)selectSQLiteDataBase:(NSString *)dataBase
                       block:(void (^) (NSArray *array))block{
    NSString *sql = [self selectTable:dataBase];
    if (!sql.length) {
        block(nil);
        return;
    }
    [AFOFMDBForeignInterface selectSQLiteTableStatements:sql model:NSStringFromClass([AFOPLThumbnail class]) block:^(NSArray *array) {
        block (array);
    }];
}
#pragma mark ------------ 删除语句
+ (NSString *)deleteAllData:(NSString *)table{
    NSString *qTable = AFOPLQuoteSQLTableName(table);
    if (!qTable) {
        return nil;
    }
    return [NSString stringWithFormat:@"DELETE FROM %@", qTable];
}
+ (NSString *)deleteGroupData:(NSString *)table id:(NSInteger)vedioId{
    NSString *qTable = AFOPLQuoteSQLTableName(table);
    if (!qTable) {
        return nil;
    }
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE \"vedio_id\" = %ld", qTable, (long)vedioId];
}
#pragma mark ------------ 删除数据
+ (void)deleateAllDataBase:(NSString *)dataBase
                  block:(void(^)(BOOL isSucess))block{
    NSString *sql = [self deleteAllData:dataBase];
    if (!sql.length) {
        block(NO);
        return;
    }
    [AFOFMDBForeignInterface deleteSQLiteTableStatements:sql block:^(BOOL isSucess) {
            block(isSucess);
    }];
}
+ (void)deleateDataBase:(NSString *)dataBase
                   data:(NSArray *)array
                  block:(void(^)(BOOL isSucess))block{

    [AFOFMDBForeignInterface deleteTransactionStatements:[self sqlsArray:array name:dataBase] block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
+ (NSArray *)sqlsArray:(NSArray *)array name:(NSString *)name{
    NSMutableArray *sqls = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFOPLThumbnail *value = obj;
        NSString *strSql = [self deleteGroupData:name id:value.vedio_id];
        if (strSql.length) {
            [sqls addObject:strSql];
        }
    }];
    return sqls;
}
- (void)dealloc{
    NSLog(@"AFOPLSQLiteManager dealloc");
}
@end
