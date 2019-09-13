//
//  AFOCardStackCollectionDataSource.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//
#import "AFOCardStackCollectionDataSource.h"
#import "AFOCardStackCollectionCell.h"
#import "AFOCardStackDefaultLayout.h"
#import "AFOCardStackingModel.h"
@interface AFOCardStackCollectionDataSource()
@property (nonatomic, strong)   AFOCardStackingModel *businessModel;
@end
@implementation AFOCardStackCollectionDataSource
#pragma mark ------ UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.cellCount;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AFOCardStackCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardStackCell" forIndexPath:indexPath];
    [cell settingTitle:[self.businessModel titleIndex:indexPath.row] image:[self.businessModel imageIndex:indexPath.row]];
    return cell;
}
#pragma mark ------ property
- (AFOCardStackingModel *)businessModel{
    if (!_businessModel) {
        _businessModel = [[AFOCardStackingModel alloc]init];
    }
    return _businessModel;
}
@end
