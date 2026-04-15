//
//  AFOPLCorresponding+GCD.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+GCD.h"
#import <AFOFoundation/AFOFoundation.h>
#import <TargetConditionals.h>
#if !TARGET_OS_SIMULATOR
#import <AFOFFMpeg/AFOFFMpeg.h>
#endif
#import "AFOPLThumbnail.h"
#import "AFOPLSQLiteManager.h"
#import "AFOPLMainFolderManager.h"
@interface AFOPLCorresponding ()
@end
@implementation AFOPLCorresponding (GCD)
#pragma mark ------ 截图
+ (void)cuttingImageSaveSqlite:(NSArray *)array
                         block:(void (^) (NSArray *itemArray))block{
    __block NSMutableArray *newArray = [[NSMutableArray alloc] init];
#if TARGET_OS_SIMULATOR
    // 模拟器不依赖 FFmpeg 静态库，返回占位数据保证流程可跑通。
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFOPLThumbnail *detail = [[AFOPLThumbnail alloc] init];
        detail.create_time = @"";
        detail.vedio_name = [obj isKindOfClass:[NSString class]] ? obj : @"";
        detail.image_name = @"";
        detail.image_width = 0;
        detail.image_hight = 0;
        [newArray addObjectAFOAbnormal:detail];
    }];
    if (block) {
        block(newArray);
    }
    return;
#else
    [[AFOMediaForeignInterface shareInstance] mediaSeekFrameUseQueue:array vediopath:[NSFileManager documentSandbox] imagePath:[AFOPLMainFolderManager mediaImagesAddress] sqlite:[AFOPLMainFolderManager dataBaseAddress] block:^(BOOL isHave,NSString *createTime,NSString *vedioName, NSString *imageName, int width, int height) {
        NSLog(@"AFOPLCorresponding+GCD: mediaSeekFrameUseQueue callback - Image Name: %@, Width: %d, Height: %d", imageName, width, height); // 添加调试日志
        [AFOPLSQLiteManager inserSQLiteDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST isHave:isHave createTime:createTime vedioName:vedioName imageName:imageName width:width height:height block:^(BOOL isFinish) {
            if (isFinish) {
                AFOPLThumbnail *detail = [[AFOPLThumbnail alloc] init];
                detail.create_time =createTime;
                detail.vedio_name = vedioName;
                detail.image_name = imageName;
                detail.image_width = width;
                detail.image_hight = height;
                [newArray addObjectAFOAbnormal:detail];
                NSLog(@"成功插入数据!");
            }
        }];
        block(newArray);
    }];
#endif
}
@end
