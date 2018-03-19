//
//  AFOSandboxOperation.m
//  AFOSandbox
//
//  Created by xueguang xian on 2018/1/9.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOSandboxOperation.h"

@implementation AFOSandboxOperation

#pragma mark ------------ 获取沙盒主目录路径
+ (NSString *)homeDirectory{
    return NSHomeDirectory();
}
#pragma mark ------------ 获取Documents目录路径
+ (NSString *)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}
#pragma mark ------------ 获取Library的目录路径
+ (NSString *)libraryDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark ------------ 获取Caches目录路径
+ (NSString *)cachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}
#pragma mark ------------ 获取tmp目录路径
+ (NSString *)temporaryDirectory{
    return NSTemporaryDirectory();
}
@end
