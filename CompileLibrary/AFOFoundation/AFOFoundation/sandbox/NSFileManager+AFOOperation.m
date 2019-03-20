//
//  NSFileManager+AFOOperation.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO Science Technology Ltd. All rights reserved.
//

#import "NSFileManager+AFOOperation.h"

@implementation NSFileManager (AFOOperation)
#pragma mark ------ 创建文件夹
+ (NSString *)createFolderTarget:(NSString *)target
                       newFolder:(NSString *)name {
    NSString *dataFilePath = [target stringByAppendingPathComponent:name]; // 在指定目录下创建 "head" 文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dataFilePath;
}
#pragma mark ------ 删除文件
+ (void)deleteFileFromSandBox:(NSString *)filePath
                        block:(void(^)(BOOL isRemove))block{
    BOOL isRemove = false;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        isRemove = [fileManager removeItemAtPath:filePath error:nil];
    }
    block(isRemove);
}
@end
