//
//  AFOPLCorresponding+SQLite.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+SQLite.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOPLSQLiteManager.h"
#import "AFOPLMainFolderManager.h"
@implementation AFOPLCorresponding (SQLite)
#pragma mark ------------ 创建数据库和表
+ (void)createDataBaseAndTable{
    [AFOPLMainFolderManager mediaImagesCacheFolder];
    //
    NSString *strPath = [NSFileManager createFolderTarget:[NSFileManager cachesDocumentSandbox] newFolder:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST];
    if (strPath != nil) {
        [AFOPLSQLiteManager createSQLiteDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST path:[AFOPLMainFolderManager dataBaseName:strPath] block:^(BOOL isFinish) {
            if (isFinish) {
                NSLog(@"创建数据库、表成功");
            }
        }];
    }
}
#pragma mark ------------ 获取数据库所有数据
+ (NSArray *)getDataFromDataBase{
    __block NSArray *data = NULL;
    [AFOPLSQLiteManager selectSQLiteDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST block:^(NSArray *array) {
        data = array;
    }];
    return data;
}
#pragma mark ------ 删除数据库数据
+ (void)deleateAllDataBaseFromSqlLite:(void(^)(BOOL isSucess))block{
    [AFOPLSQLiteManager deleateAllDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
+ (void)deleateDataBaseFromSqlLite:(NSArray *)array
                             block:(void(^)(BOOL isSucess))block{
    [AFOPLSQLiteManager deleateDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST data:array block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
@end
