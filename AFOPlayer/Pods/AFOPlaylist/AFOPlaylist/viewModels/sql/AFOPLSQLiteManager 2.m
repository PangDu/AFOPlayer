//
//  AFOPlaylistSQLiteManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLSQLiteManager.h"
#import <AFOSQLite/AFOSQLite.h>
#import "AFOPLThumbnail.h"
@implementation AFOPLSQLiteManager
#pragma mark ------------ 创建表
+ (NSString *)createTable:(NSString *)name{
    NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE '%@' ('vedio_id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'vedio_name' VARCHAR(255),'image_name' VARCHAR(255), 'create_time' VARCHAR(255) ,'image_width' INTEGER,'image_hight' INTEGER)",name];
    return createTable;
}
#pragma mark ------------ 创建数据库
+ (void)createSQLiteDataBase:(NSString *)dataBase
                        path:(NSString *)path
                       block:(void (^)(BOOL isFinish))block{
    [AFOFMDBForeignInterface createSQLiteTable:dataBase path:path statements:[self createTable:dataBase] block:^(BOOL isSucessed) {
        block(isSucessed);
    }];
}
#pragma mark ------------ 插入语句
+ (NSString *)insertTable:(NSString *)table
               createTime:(NSString *)createTime
                vedioName:(NSString *)vedioName
                imageName:(NSString *)imageName
                    width:(int)width
                   height:(int)height{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(vedio_name,image_name,create_time,image_width,image_hight) VALUES('%@','%@','%@',%d,%d)",table,vedioName,imageName,createTime,width,height];
    return sql;
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
    NSString *sql = [self insertTable:dataBase createTime:createTime vedioName:vedioName imageName:imageName width:width height:height];
    [AFOFMDBForeignInterface insertSQLiteTableStatements:sql block:^(BOOL isSucessed) {
        block(isSucessed);
    }];
}
#pragma mark ------------ 查询语句
+ (NSString *)selectTable:(NSString *)table{
    NSString *sql = [NSString stringWithFormat:@"select * from %@",table];
    return sql;
}
#pragma mark ------------ 查询数据 
+ (void)selectSQLiteDataBase:(NSString *)dataBase
                       block:(void (^) (NSArray *array))block{
    [AFOFMDBForeignInterface selectSQLiteTableStatements:[self selectTable:dataBase] model:NSStringFromClass([AFOPLThumbnail class]) block:^(NSArray *array) {
        block (array);
    }];
}
#pragma mark ------------ 删除语句
+ (NSString *)deleteAllData:(NSString *)table{
    NSString *sql = [NSString stringWithFormat:@"delete from %@",table];
    return sql;
}
+ (NSString *)deleteGroupData:(NSString *)table id:(NSInteger)vedioId{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where vedio_id = %ld",table,(long)vedioId];
    return sql;
}
#pragma mark ------------ 删除数据
+ (void)deleateAllDataBase:(NSString *)dataBase
                  block:(void(^)(BOOL isSucess))block{
    NSString *sql = [self deleteAllData:dataBase];
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
        [sqls addObject:strSql];
    }];
    return sqls;
}
- (void)dealloc{
    NSLog(@"AFOPLSQLiteManager dealloc");
}
@end
