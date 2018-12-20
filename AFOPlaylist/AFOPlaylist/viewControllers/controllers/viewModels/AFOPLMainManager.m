//
//  AFOPLMainManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//
#import "AFOPLMainManager.h"
@interface AFOPLMainManager ()<AFOReadDirectoryFileDelegate>
@property (nonnull, nonatomic, strong) AFOReadDirectoryFile       *directoryFile;
@property (nonnull, nonatomic, strong) AFOPLCorresponding         *corresponding;
@property (nonnull, nonatomic, strong) NSMutableArray             *dataArray;
@property (nonnull, nonatomic, strong) NSMutableArray             *nameArray;
@property (nonatomic, assign)           BOOL                       isUpdate;
@property (nonatomic, weak) id<AFOPLMainManagerDelegate>          delegate;
@end
@implementation AFOPLMainManager
#pragma mark ------------ init
#pragma mark ------ AFOPLMainManager
+ (AFOPLMainManager *)mainManagerDelegate:(id)managerDelegate{
    AFOPLMainManager *manager = NULL;
    if (managerDelegate != NULL){
        AFOPLMainManager *tempManager = [[AFOPLMainManager alloc] init];
        tempManager.delegate = managerDelegate;
        [tempManager readDirectoryFile];
        manager = tempManager;
    }
    return manager;
}
#pragma mark ------ readDirectoryFile
- (void)readDirectoryFile{
    self.isUpdate = YES;
    [AFOPLCorresponding createDataBase];
    _directoryFile = [AFOReadDirectoryFile readDirectoryFiledelegate:self];
}
#pragma mark ------ 获取图片高度
- (CGFloat)thumbnailHight:(NSIndexPath *)indexPath width:(CGFloat)width{
    AFOPLThumbnail *detail = [self.dataArray objectAtIndexAFOAbnormal:indexPath.item];
    CGFloat height = 0;
    if (width < detail.image_width) {
        height = detail.image_hight * (detail.image_width / width);
    }
     height = detail.image_hight * (width / detail.image_width);
    return height;
}
#pragma mark ------ 视频地址
- (NSString *)vedioAddressIndexPath:(NSIndexPath *)indexPath{
    NSString *path = [[NSFileManager documentSandbox] stringByAppendingString:@"/"];
    return [path stringByAppendingString:[self vedioNameIndexPath:indexPath]];
}
#pragma mark ------ 视频名
- (NSString *)vedioNameIndexPath:(NSIndexPath *)indexPath{
    AFOPLThumbnail *detail = [self.dataArray objectAtIndexAFOAbnormal:indexPath.item];
    return detail.vedio_name;
}
#pragma mark ------ 横竖屏
- (UIInterfaceOrientationMask)orientationMask:(NSIndexPath *)indexPath{
    AFOPLThumbnail *model = [self.dataArray objectAtIndexAFOAbnormal:indexPath.item];
    if (model) {
        if (model.image_width < model.image_hight) {
            return UIInterfaceOrientationMaskPortrait;
        }
    }
    return UIInterfaceOrientationMaskLandscapeLeft;
}
#pragma mark ------ 获取最新数据
- (void)getThumbnailData:(void (^)(NSArray *array,
                                   BOOL isUpdate))block{
    [self.dataArray removeAllObjects];
    NSArray *addArray = [AFOPLCorresponding getUnscreenshotsArray:self.nameArray compare:[AFOPLCorresponding vedioName:[AFOPLCorresponding getDataFromDataBase]]];
    if (addArray.count > 0 && [AFOPLCorresponding getDataFromDataBase] == 0) {
        [AFOPLCorresponding cuttingImageSaveSqlite:addArray block:^(NSArray *itemArray) {
            [self.dataArray addObjectsFromArrayAFOAbnormal:itemArray];
            block(self.dataArray, self.isUpdate);
        }];
        self.isUpdate = YES;
    }else if(addArray.count == 0 && [AFOPLCorresponding getAllDataFromDataBase].count > 0){
        [self.dataArray addObjectsFromArrayAFOAbnormal:[AFOPLCorresponding getAllDataFromDataBase]];
        block(self.dataArray, self.isUpdate);
        self.isUpdate = NO;
    }else if(addArray.count > 0 && [AFOPLCorresponding getDataFromDataBase] > 0){
        [self.dataArray addObjectsFromArrayAFOAbnormal:[AFOPLCorresponding getAllDataFromDataBase]];
        [AFOPLCorresponding cuttingImageSaveSqlite:addArray block:^(NSArray *itemArray) {
            [self.dataArray addObjectsFromArrayAFOAbnormal:itemArray];
            block(self.dataArray, self.isUpdate);
        }];
        self.isUpdate = YES;
    }
}
- (void)getsUnshotMovie:(NSArray *)array{
    NSArray *addArray = [AFOPLCorresponding getUnscreenshotsArray:array compare:[AFOPLCorresponding vedioName:[AFOPLCorresponding getDataFromDataBase]]];
    if (!addArray.count) {
        return;
    }
    [AFOPLCorresponding cuttingImageSaveSqlite:addArray block:^(NSArray *itemArray) {
        [self.dataArray addObjectAFOAbnormal:itemArray];
    }];
}
#pragma mark ------------------ 删除影片相关内容
+ (void)deleteMovieRelatedContentLocally:(NSArray *)array
                                   block:(void (^)(BOOL isSucess))block{
    BOOL isAll = NO;
    if (array.count == [AFOPLCorresponding getAllDataFromDataBase].count) {
        isAll = YES;
    }
    ///---
    dispatch_queue_t queue_t = dispatch_queue_create("com.AFOPLMainManager.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group_t = dispatch_group_create();
    ///--- 删除视频
    __block BOOL isRemoveVedio;
    dispatch_group_async(group_t, queue_t, ^{
        __block NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            AFOPLThumbnail *detail = obj;
            NSString *vedioPath = [AFOPLMainFolderManager vedioAddress:detail.vedio_name];
            [nameArray addObject:vedioPath];
        }];
        ///---
        [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [AFOPLMainFolderManager deleteFileFromDocument:obj type:AFOPLMainFileTypeVedio isAll:isAll block:^(BOOL isDelete) {
                if (isDelete) {
                    isRemoveVedio = isDelete;
                }else{
                    isRemoveVedio = NO;
                    return;
                }
            }];
        }];
    });
    ///--- 删除缩略图
    __block BOOL isRemoveImage;
    dispatch_group_async(group_t, queue_t, ^{
        if (!isRemoveVedio) {
            return;
        }
        if (!isAll) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AFOPLThumbnail *detail = obj;
                NSString *imagePath = [AFOPLMainFolderManager imageAddress:detail.image_name];
                [AFOPLMainFolderManager deleteFileFromDocument:imagePath type:AFOPLMainFileTypeImage isAll:isAll block:^(BOOL isDelete) {
                    isRemoveImage = isDelete;
                }];
            }];
        }else{
            [AFOPLMainFolderManager deleteFileFromDocument:nil type:AFOPLMainFileTypeImage isAll:isAll block:^(BOOL isDelete) {
                isRemoveImage = isDelete;
            }];
        }
        if (![AFOPLMainFolderManager mediaImagesCacheFolder]) {
            return;
        }
    });
    ///--- 删除数据库信息
    __block BOOL isRemoveDataBase = NO;
    dispatch_group_async(group_t, queue_t, ^{
        if (!isRemoveImage) {
            return;
        }
        if (isAll) {
            [AFOPLMainManager deleteAllDataFromDataBase:^(BOOL isSucess){
                isRemoveDataBase = isSucess;
            }];
        }else{
            [AFOPLMainManager deleteDataFromDataBase:array block:^(BOOL isSucess) {
                isRemoveDataBase = isSucess;
            }];
        }

    });
    ///--- 任务全部完成
    dispatch_group_notify(group_t, queue_t, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isRemoveDataBase && isRemoveImage && isRemoveVedio) {
                block(YES);
            }else{
                block(NO);
            }
        });
    });
}
#pragma mark ------ 删除数据库中数据
+ (void)deleteAllDataFromDataBase:(void(^)(BOOL isSucess))block{
    [AFOPLCorresponding deleteAllDataFromDataBase:^(BOOL isSucess) {
        block(isSucess);
    }];
}
+ (void)deleteDataFromDataBase:(NSArray *)array
                         block:(void(^)(BOOL isSucess))block{
    [AFOPLCorresponding deleteDataFromDataBase:array block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
#pragma mark ------ AFOReadDirectoryFileDelegate
- (void)directoryFromDocument:(NSArray *)array{
    [self.nameArray removeAllObjects];
    [self.nameArray addObjectsFromArrayAFOAbnormal:array];
}
#pragma mark ------------ property
#pragma mark ------ corresponding
- (AFOPLCorresponding *)corresponding{
    if (!_corresponding) {
        _corresponding = [AFOPLCorresponding correspondingDelegate:self];
    }
    return _corresponding;
}
#pragma mark ------ dataArray
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark ------ nameArray
- (NSMutableArray *)nameArray{
    if (!_nameArray) {
        _nameArray = [[NSMutableArray alloc] init];
    }
    return _nameArray;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPLMainManager dealloc");
}
@end
