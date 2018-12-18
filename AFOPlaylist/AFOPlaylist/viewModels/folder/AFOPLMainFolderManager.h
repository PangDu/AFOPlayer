//
//  AFOPLMainFolderManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/6.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AFO_PLAYLIST_SCREENSHOTSVEDIOLIST @"Corresponding"

typedef NS_OPTIONS(NSUInteger, AFOPLMainFileType) {
    AFOPLMainFileTypeImage = 1,
    AFOPLMainFileTypeVedio = 2
};
typedef void(^fileExistBlock)(BOOL isHave, NSString *filePath);
@interface AFOPLMainFolderManager : NSObject
+ (NSString *)mediaImagesCacheFolder;
+ (NSString *)dataBaseAddress;
+ (NSString *)mediaImagesAddress;
+ (NSString *)dataBaseName:(NSString *)path;
+ (NSString *)vedioAddress:(NSString *)vedioName;
+ (NSString *)imageAddress:(NSString *)imageName;
+ (void)deleteFileFromDocument:(NSString *)strPath
                          type:(AFOPLMainFileType)type
                         isAll:(BOOL)isAll
                         block:(void(^)(BOOL isDelete))block;
@end
