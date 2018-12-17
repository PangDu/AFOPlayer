//
//  AFOPLCorresponding+GCD.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+GCD.h"
@interface AFOPLCorresponding ()
@property (nonnull, nonatomic, strong) dispatch_queue_t   dispatchQueue_t;
@end
@implementation AFOPLCorresponding (GCD)
#pragma mark ------------property
- (void)setDispatchQueue_t:(dispatch_queue_t)dispatchQueue_t{
    objc_setAssociatedObject(self, @selector(setDispatchQueue_t:), dispatchQueue_t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (dispatch_queue_t)dispatchQueue_t{
    return objc_getAssociatedObject(self, @selector(setDispatchQueue_t:));
}
#pragma mark ------ 添加数据
- (void)usedispatchQueue:(NSArray *)saveArray
                    array:(NSArray *)array
                    block:(void (^) (NSArray *array))block{
    ///------
    self.dispatchQueue_t = dispatch_queue_create("com.AFOPlayer.AFOPLCorresponding", DISPATCH_QUEUE_SERIAL);
    ///------
    if (array.count > saveArray.count) {///最新添加未截图
    ///------ 先显示已有截图
    block([AFOPLCorresponding getDataFromDataBase]);
    //
    NSArray *addArray = [AFOPLCorresponding getUnscreenshotsArray:array compare:[AFOPLCorresponding vedioName:saveArray]];
    [self cuttingImageSaveSqlite:addArray block:^(NSArray *array) {
            }];
    }
}
#pragma mark ------ 截图
- (void)cuttingImageSaveSqlite:(NSArray *)array
                         block:(void (^) (NSArray * array))block{
    ///------
    self.dispatchQueue_t = dispatch_queue_create("com.AFOPlayer.AFOPLCorresponding", DISPATCH_QUEUE_SERIAL);
    ///------
    __block NSMutableArray *newArray = [[NSMutableArray alloc] init];
    dispatch_apply(array.count, self.dispatchQueue_t, ^(size_t index) {
        [[AFOMediaForeignInterface shareInstance] mediaSeekFrameUseQueue:array[index] vediopath:[NSFileManager documentSandbox] imagePath:[AFOPLMainFolderManager mediaImagesAddress] sqlite:[AFOPLMainFolderManager dataBaseAddress] block:^(BOOL isHave,NSString *createTime,NSString *vedioName, NSString *imageName, int width, int height) {
            [AFOPLSQLiteManager inserSQLiteDataBase:AFOPLAYLISTSCREENSHOTSVEDIOLIST isHave:isHave createTime:createTime vedioName:vedioName imageName:imageName width:width height:height block:^(BOOL isFinish) {
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
        }];
    });
    ///------
    block(newArray);
}
@end
