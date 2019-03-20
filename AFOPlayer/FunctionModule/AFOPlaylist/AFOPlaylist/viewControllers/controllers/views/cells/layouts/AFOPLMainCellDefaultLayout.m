//
//  AFOPLMainCollectionCellDefaultLayout.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainCellDefaultLayout.h"
@interface AFOPLMainCellDefaultLayout ()
@property (nonatomic, assign) CGFloat               spacingWidth;
@property (nonatomic, assign) CGFloat               spacingWidthTotal;
@property (nonatomic, assign) CGFloat               lineWidth;
@property (nonatomic, assign) CGFloat               spacingLeft;
@property (nonatomic, assign) CGFloat               spacingRight;
@property (nonatomic, assign) CGFloat               spacingTop;
@property (nonatomic, assign) CGFloat               spacingBottom;
@property (nonatomic, assign) NSInteger             itemCount;
@property (nonatomic, assign) NSInteger             spacingCount;
@property (nonatomic, strong) NSMutableArray       *attributesArray;
@property (nonatomic, strong) NSMutableDictionary  *maxDictionary;
@end

@implementation AFOPLMainCellDefaultLayout
#pragma mark ------ 准备方法被自动调用，以保证layout实例的正确。
- (void)prepareLayout{
    [super prepareLayout];
    //初始化字典，有几列就有几个键值对，key为列，value为列的最大y值，初始值为上内边距
    for (int i = 0; i < self.itemCount; i++) {
        self.maxDictionary[@(i)] = @(self.spacingTop);
    }
    ///------
    [self.attributesArray removeAllObjects];
    NSInteger count =[self.collectionView   numberOfItemsInSection:0];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath =[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObjectAFOAbnormal:attrs];
    }
}
#pragma mark ------ 返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize{
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.maxDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxDictionary[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxDictionary[maxIndex] floatValue] + self.spacingBottom);
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    ///------ 根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes * attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    ///------ 获取collectionView的宽度
    CGFloat width =CGRectGetWidth(self.collectionView.frame);
    
    ///------ item width = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (width - self.spacingLeft -self.spacingRight - self.spacingWidthTotal)/self.itemCount;
    
    ///------ item hight
    CGFloat itemHeight = self.block(itemWidth, indexPath);
    
    //找出最短的那一列
    __block NSNumber *minIndex = @(0);
    [self.maxDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxDictionary[minIndex] floatValue] > obj.floatValue) {
            minIndex = key;
        }
    }];
    
    ///------ item X
    CGFloat itemX = self.spacingLeft +  (self.spacingWidth + itemWidth) * minIndex.integerValue;
    
    ///------ item Y
    CGFloat itemY = [self.maxDictionary[minIndex] floatValue] + self.lineWidth;
    
    ///------ 设置attributes的frame
    attributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    ///------ 更新字典中的最大y值
    self.maxDictionary[minIndex] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}
#pragma mark ------ 返回rect中的所有的元素的布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}
#pragma mark ------------ property
#pragma mark ------
- (CGFloat)spacingWidthTotal{
    return self.spacingCount * self.spacingWidth;
}
#pragma mark ------ spacingCount
- (NSInteger)spacingCount{
    return self.itemCount - 1;
}
#pragma mark ------ itemCount
- (NSInteger)itemCount{
    return _itemCount = 2;
}
#pragma mark ------ spacing
- (CGFloat)spacingWidth{
    return _spacingWidth = 5;
}
#pragma mark ------ lineWidth
- (CGFloat)lineWidth{
    return _lineWidth = 5;
}
#pragma mark ------ spacingLeft
- (CGFloat)spacingLeft{
    return _spacingLeft = 5;
}
#pragma mark ------ spacingRight
- (CGFloat)spacingRight{
    return _spacingRight = 5;
}
#pragma mark ------ spacingTop
- (CGFloat)spacingTop{
    return _spacingTop = 5;
}
#pragma mark ------ spacingBottom
- (CGFloat)spacingBottom{
    return _spacingBottom = 5;
}
#pragma mark ------ attributesArray
- (NSMutableArray *)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}
#pragma mark ------ maxDictionary
- (NSMutableDictionary *)maxDictionary{
    if (!_maxDictionary) {
        _maxDictionary = [[NSMutableDictionary alloc] init];
    }
    return _maxDictionary;
}
@end
