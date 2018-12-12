//
//  AFOPLMainFolderManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/6.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AFOPLAYLISTSCREENSHOTSVEDIOLIST @"Corresponding"

typedef void(^fileExistBlock)(BOOL isHave, NSString *filePath);
@interface AFOPLMainFolderManager : NSObject
+ (NSString *)mediaImagesCacheFolder;
+ (NSString *)dataBaseAddress;
+ (NSString *)mediaImagesAddress;
+ (NSString *)dataBaseName:(NSString *)path;
+ (void)deleteFileFromDocument:(NSString *)path
                         isAll:(BOOL)isAll
                         block:(void(^)(BOOL isDelete))block;
@end
