//
//  NSFileManager+AFOSandBox.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSFileManager+AFOSandBox.h"

@implementation NSFileManager (AFOSandBox)
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
#pragma mark ------------ 获取沙盒主目录路径
+ (NSString *)homeDirectory{
    return NSHomeDirectory();
}
#pragma mark ------------ 获取Library的目录路径
+ (NSString *)libraryDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark ------------ 获取tmp目录路径
+ (NSString *)temporaryDirectory{
    return NSTemporaryDirectory();
}
@end
