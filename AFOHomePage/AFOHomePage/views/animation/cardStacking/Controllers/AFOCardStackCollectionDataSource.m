//
//  AFOCardStackCollectionDataSource.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFOCardStackCollectionDataSource.h"
#import "AFOCardStackCollectionCell.h"
#import "AFOCardStackDefaultLayout.h"

@interface AFOCardStackCollectionDataSource()

@end
@implementation AFOCardStackCollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.cellCount;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AFOCardStackCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardStackCell" forIndexPath:indexPath];
    cell.backgroundColor = [self getGameColor:indexPath.row];
    [cell settingCellControl:indexPath];
    return cell;
}
-(UIColor*)getGameColor:(NSInteger)index
{
    NSArray* colorList = @[RGBColorC(0xfb742a),RGBColorC(0xfcc42d),RGBColorC(0x29c26d),RGBColorC(0xfaa20a),RGBColorC(0x5e64d9),RGBColorC(0x6d7482),RGBColorC(0x54b1ff),RGBColorC(0xe2c179),RGBColorC(0x9973e5),RGBColorC(0x61d4ff)];
    UIColor* color = [colorList objectAtIndex:(index%10)];
    return color;
}
@end
