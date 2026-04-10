//
//  AFOPLMainCollectionDataSource.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainCollectionDataSource.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOPLMainCollectionCell.h"
@interface AFOPLMainCollectionDataSource ()
@property (nonnull, nonatomic, strong) NSMutableArray       *dataArray;
@end
@implementation AFOPLMainCollectionDataSource
#pragma mark ------
- (void)settingImageData:(NSArray *)array{
    [self.dataArray removeAllObjects];
    if (array) {
        [self.dataArray addObjectsFromArrayAFOAbnormal:array];
    }
}
#pragma mark ------------ UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AFOPLMainCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AFOPLMainCollectionCell class]) forIndexPath:indexPath];
    cell.indexPath = indexPath; // 设置 cell 的 indexPath
    // 设置 imageLoadedBlock，当图片加载完成后，通知 CollectionView 重新布局
    WeakObject(collectionView); // 避免循环引用
    cell.imageLoadedBlock = ^(NSIndexPath * _Nullable loadedIndexPath) {
        StrongObject(collectionView);
        // 移除了 performBatchUpdates 和 invalidateLayout，依赖 cell 自身的布局更新
        if (collectionView && loadedIndexPath) {
            // [collectionView reloadItemsAtIndexPaths:@[loadedIndexPath]]; // 也可以尝试刷新单个 item
        }
    };
    [cell settingSubViews:[self.dataArray objectAtIndexAFOAbnormal:indexPath.item]];
    return cell;
}
#pragma mark ------ property
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPLMainCollectionDataSource dealloc");
}
@end
