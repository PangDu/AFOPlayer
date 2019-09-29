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
