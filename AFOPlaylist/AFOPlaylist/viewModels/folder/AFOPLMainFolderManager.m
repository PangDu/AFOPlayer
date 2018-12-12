//
//  AFOPLMainFolderManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/6.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainFolderManager.h"

#define AFOPLAYLISTTHUMBNAILFOLDER @"MediaImages"

@implementation AFOPLMainFolderManager
#pragma mark ------ 创建截图文件地址
+ (NSString *)mediaImagesCacheFolder{
    NSString *cach = [NSFileManager cachesDocumentSandbox];
    NSString *path = [NSFileManager createFolderTarget:cach newFolder:AFOPLAYLISTTHUMBNAILFOLDER];
    return path;
}
#pragma mark ------ MediaImages
+ (NSString *)mediaImagesAddress{
    return  [[NSFileManager cachesDocumentSandbox] stringByAppendingString:[NSString stringWithFormat:@"/%@",AFOPLAYLISTTHUMBNAILFOLDER]];
}
#pragma mark ------ dataBaseAddress
+ (NSString *)dataBaseAddress{
    NSString *pathpath = [[NSFileManager cachesDocumentSandbox] stringByAppendingString:[NSString stringWithFormat:@"/%@.db",AFOPLAYLISTSCREENSHOTSVEDIOLIST]];
    return pathpath;
}
#pragma mark ------ dataBaseName
+ (NSString *)dataBaseName:(NSString *)path{
    NSString *name = [NSString stringWithFormat:@"/%@.db",AFOPLAYLISTSCREENSHOTSVEDIOLIST];
    return [path stringByAppendingString:name];
}
+ (void)deleteFileFromDocument:(NSString *)path
                         isAll:(BOOL)isAll
                         block:(void(^)(BOOL isDelete))block{
    if (isAll) {
        path = [self mediaImagesAddress];
    }
    [NSFileManager deleteFileFromSandBox:path block:^(BOOL isRemove) {
        block(isRemove);
    }];
}
@end
