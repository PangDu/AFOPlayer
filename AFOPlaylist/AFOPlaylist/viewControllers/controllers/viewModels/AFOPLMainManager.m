//
//  AFOPLMainManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainManager.h"
#import "AFOReadDirectoryFile.h"
#import "AFOPLMainFolderManager.h"
#import "AFOPLCorresponding.h"
#import "AFOPLThumbnail.h"
@interface AFOPLMainManager ()<AFOReadDirectoryFileDelegate>
@property (nonatomic, strong) AFOReadDirectoryFile       *directoryFile;
@property (nonatomic, strong) AFOPLCorresponding         *corresponding;
@property (nonatomic, strong) NSMutableArray             *dataArray;
@property (nonatomic, strong) NSMutableArray             *nameArray;
@property (nonatomic, weak) id<AFOPLMainManagerDelegate>  delegate;
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
#pragma mark ------------ custom
#pragma mark ------ readDirectoryFile
- (void)readDirectoryFile{
    [self.corresponding createDataBase];
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
#pragma mark ------ 获取最新数据
- (void)getThumbnailData:(void (^)(NSArray *array,
                                   NSArray *indexArray,
                                   BOOL isUpdate))block{
    __weak __typeof(self) weakSelf = self;
    [self.corresponding mediathumbnail:self.nameArray block:^(NSArray *array,
                                                         NSArray *indexArray,
                                                              BOOL isUpdate) {
        if (array) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArrayAFOAbnormal:array];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                block(array, indexArray, isUpdate);
            }];
        }
    }];
}
#pragma mark ------------------ 删除影片相关内容
+ (void)deleteMovieRelatedContentLocally{
    dispatch_queue_t queue_t = dispatch_queue_create("com.AFOPLMainManager.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_group_t group_t = dispatch_group_create();
    ///--- 删除数据库信息
    __block BOOL isDataBase = NO;
    dispatch_semaphore_t  semaphore_t = dispatch_semaphore_create(1);
    dispatch_group_async(group_t, queue_t, ^{
        dispatch_semaphore_wait(semaphore_t, DISPATCH_TIME_FOREVER);
        [AFOPLMainManager deleteDataFromDataBase:^(BOOL isSucess) {
            isDataBase = isSucess;
            dispatch_semaphore_signal(semaphore_t);
        }];
    });
    ///--- 删除缩略图
    __block BOOL isRemove;
    dispatch_group_async(group_t, queue_t, ^{
        if (!isDataBase) {
            return;
        }
        [AFOPLMainFolderManager deleteFileFromDocument:nil isAll:YES block:^(BOOL isDelete) {
            isRemove = isDelete;
        }];
    });
    ///--- 删除视频
    dispatch_group_async(group_t, queue_t, ^{
        if (!isRemove) {
            return;
        }
    });
    ///--- 任务全部完成
    dispatch_group_notify(group_t, queue_t, ^{
        
    });
}
#pragma mark ------ 删除数据库中数据
+ (void)deleteDataFromDataBase:(void(^)(BOOL isSucess))block{
    [AFOPLCorresponding deleteDataFromDataBase:^(BOOL isSucess) {
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
@end
