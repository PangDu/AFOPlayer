//
//  AFOPLMainCollectionCellDefaultLayout.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainCellDefaultLayout.h"
#import <AFOFoundation/AFOFoundation.h>
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

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemCount = 2;
        _spacingWidth = 0;
        _lineWidth = 0;
        _spacingLeft = 0;
        _spacingRight = 0;
        _spacingTop = 0;
        _spacingBottom = 0;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)prepareLayout{
    [super prepareLayout];
    [self.maxDictionary removeAllObjects]; // 强制清空旧的 maxDictionary
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

#pragma mark - CollectionView Content Size

- (CGSize)collectionViewContentSize{
    __block NSNumber *maxIndex = @0;
    //遍历字典，找出最长的那一列
    [self.maxDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSNumber *obj, BOOL *stop) {
        if ([self.maxDictionary[maxIndex] floatValue] < obj.floatValue) {
            maxIndex = key;
        }
    }];
    CGFloat contentHeight = [self.maxDictionary[maxIndex] floatValue] + self.spacingBottom;
#if DEBUG
    NSLog(@"AFOPLMainCellDefaultLayout: Content Size Height: %f", contentHeight); // 添加日志
#endif
    //collectionView的contentSize.height就等于最长列的最大y值+下内边距
    return CGSizeMake(0, [self.maxDictionary[maxIndex] floatValue] + self.spacingBottom);
}

#pragma mark - Layout Attributes

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    ///------ 根据indexPath获取item的attributes
    UICollectionViewLayoutAttributes * attributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    ///------ 获取collectionView的宽度
    CGFloat width =CGRectGetWidth(self.collectionView.frame);
#if DEBUG
    NSLog(@"AFOPLMainCellDefaultLayout: CollectionView Frame Width: %f", width); // 添加日志
#endif
    ///------ item width = (collectionView的宽度 - 内边距与列间距) / 列数
    CGFloat itemWidth = (width - self.spacingLeft -self.spacingRight - self.spacingWidthTotal)/self.itemCount;
#if DEBUG
    NSLog(@"AFOPLMainCellDefaultLayout: Calculated Item Width: %f", itemWidth); // 添加日志    
#endif
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

#pragma mark - Layout Attributes for Elements in Rect

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attributesArray;
}

#pragma mark - Invalidate Layout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Properties

- (CGFloat)spacingWidthTotal{
    return self.spacingCount * self.spacingWidth;
}

- (NSInteger)spacingCount{
    return self.itemCount - 1;
}

- (NSInteger)itemCount{
    return _itemCount;
}

- (CGFloat)spacingWidth{
    return _spacingWidth;
}

- (CGFloat)lineWidth{
    return _lineWidth;
}

- (CGFloat)spacingLeft{
    return _spacingLeft;
}

- (CGFloat)spacingRight{
    return _spacingRight;
}

- (CGFloat)spacingTop{
    return _spacingTop;
}

- (CGFloat)spacingBottom{
    return _spacingBottom;
}

- (NSMutableArray *)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    return _attributesArray;
}

- (NSMutableDictionary *)maxDictionary{
    if (!_maxDictionary) {
        _maxDictionary = [[NSMutableDictionary alloc] init];
    }
    return _maxDictionary;
}

@end
