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
