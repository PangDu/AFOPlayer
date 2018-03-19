//
//  NSFileManager+AFOSandBox.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSFileManager+AFOSandBox.h"

@implementation NSFileManager (AFOSandBox)
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
#pragma mark ------------ document
+ (NSString *)documentSandbox{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docsdir;
}
#pragma mark ------------ caches
+ (NSString *)cachesDocumentSandbox{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return cachesPath;
}
@end
