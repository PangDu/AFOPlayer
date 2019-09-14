//
//  AFOPLCorresponding+GCD.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+GCD.h"
@interface AFOPLCorresponding ()
@end
@implementation AFOPLCorresponding (GCD)
#pragma mark ------ 截图
+ (void)cuttingImageSaveSqlite:(NSArray *)array
                         block:(void (^) (NSArray *itemArray))block{
    __block NSMutableArray *newArray = [[NSMutableArray alloc] init];
    [[AFOMediaForeignInterface shareInstance] mediaSeekFrameUseQueue:array vediopath:[NSFileManager documentSandbox] imagePath:[AFOPLMainFolderManager mediaImagesAddress] sqlite:[AFOPLMainFolderManager dataBaseAddress] block:^(BOOL isHave,NSString *createTime,NSString *vedioName, NSString *imageName, int width, int height) {
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
}
@end
