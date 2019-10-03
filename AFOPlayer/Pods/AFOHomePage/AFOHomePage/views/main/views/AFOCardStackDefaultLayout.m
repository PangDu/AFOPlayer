//
//  AFOCardStackDefaultLayout.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOCardStackDefaultLayout.h"

@interface AFOCardStackDefaultLayout ()
/**
 是指当第0个cell从初始位置，往上滑m0个点时卡片会移动到最顶点
 */
@property (nonatomic, assign)  CGFloat         m0;
/**
 当contentOffset.y为0时，第0个cell的y坐标为n0
 */
@property (nonatomic, assign)  CGFloat         n0;
/**
 每个cell之间的偏移量间距，即第0个cell往下滑动deltaOffsetY个点时会到达第1个cell的位置
 */
@property (nonatomic, assign) CGFloat         deltaOffsetY;
/**
 <#Description#>
 */
@property (nonatomic, assign) CGFloat         cellWidth;

/**
 <#Description#>
 */
@property (nonatomic, assign) CGFloat         cellHeight;

/**
 <#Description#>
 */
@property (nonatomic, strong) NSMutableArray *cellArray;

/**
 <#Description#>
 */
@property (nonatomic, strong) NSMutableArray *blurList;
@end

@implementation AFOCardStackDefaultLayout
#pragma mark ------ layoutAttributesIndexPath
- (UICollectionViewLayoutAttributes *)layoutAttributesIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(self.cellWidth, self.cellHeight);
    
    //计算位置
    CGFloat originY = [self getOriginYWithOffsetY:self.collectionView.contentOffset.y row:indexPath.row];
    CGFloat centerY = originY + self.collectionView.contentOffset.y + self.cellHeight/2.0;
    attributes.center = CGPointMake(CGRectGetWidth(self.collectionView.frame) / 2,centerY);
    
    //计算缩放比例
    CGFloat rat = [self transformRatio:originY];
    attributes.transform = CGAffineTransformMakeScale(rat, rat);
    
    //计算透明度
    //y = (1-1.14x)^0.3
    CGFloat blur = 0;
    if ((1-1.13*rat) < 0 ) {
        blur = 0;
    }else{
        blur = powf((1-1.13*rat), 0.3);
    }
    attributes.zIndex = originY;    //这里设置zIndex，是为了cell的层次顺序达到下面的cell覆盖上面的cell的效果
    return attributes;
}
#pragma mark ------ 根据下标、当前偏移量来获取对应的y坐标
-(CGFloat)getOriginYWithOffsetY:(CGFloat)offsetY row:(NSInteger)row{
    // 公式： y0 = ((m0 - x)/m0)^4*n0
    // 公式:  yi=((m0 + i*140-x)/(m0 + i*140))^4*((m0+140*i)/m0)^4*n0
    CGFloat x = offsetY;    //这里offsetY就是自变量x
    CGFloat ni = [self defaultYWithRow:row];
    CGFloat mi = self.m0 + row*self.deltaOffsetY;
    CGFloat tmp = mi - x;
    CGFloat y = 0;
    if (tmp >= 0) {
        y = powf((tmp)/mi, 4)*ni;
    }else{
        y = 0 - (self.cellHeight - tmp);
    }
    return y;
}
#pragma mark ------ 获取当contentOffset.y=0时每个cell的y值
-(CGFloat)defaultYWithRow:(NSInteger)row{
    CGFloat x0 = 0;     //初始状态
    CGFloat xi = x0 - self.deltaOffsetY*row;
    CGFloat ni = powf((self.m0 - xi)/self.m0, 4)*self.n0;
    return ni;
}
#pragma mark ------ 根据偏移量、下标获取对应的尺寸变化
-(CGFloat)transformRatio:(CGFloat)originY{
    // y = (x/range)^0.4
    if (originY < 0) {
        return 1;
    }
    CGFloat range = [UIScreen mainScreen].bounds.size.height ;
    originY = fminf(originY, range);
    CGFloat ratio = powf(originY/range, 0.04);
    return ratio;
}
#pragma mark ------
- (CGFloat)getSizePointY{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat scrollY =  self.deltaOffsetY*(rowCount-1);
    return scrollY + [UIScreen mainScreen].bounds.size.height;
}
#pragma mark ---- 每次布局都会调用
- (void)prepareLayout{
    [super prepareLayout];
    [self.cellArray removeAllObjects];
    
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger row = 0 ; row < rowCount; row++) {
        UICollectionViewLayoutAttributes* attribute = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [self.cellArray addObject:attribute];
    }
}
#pragma mark ---- 布局完成后设置contentSize
- (CGSize)collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width,[self getSizePointY]);
}
#pragma mark ---- 返回每个item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self layoutAttributesIndexPath:indexPath];
}
#pragma mark ---- 返回所有item属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *array = [NSMutableArray array];
    [self.cellArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes* attribute = obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [array addObject:attribute];
        }
    }];
    return array;
}
#pragma mark ---- 目标offset，在应用layout的时候会调用这个回调来设置collectionView的contentOffset
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset{
    return CGPointMake(0, 64*3);
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGRectEqualToRect(newBounds, self.collectionView.bounds);
}
#pragma mark ------------ property
- (CGFloat)cellWidth{
    _cellWidth = [UIScreen mainScreen].bounds.size.width -12*2;
    return _cellWidth;
}
- (CGFloat)cellHeight{
    _cellHeight = 180;
    return _cellHeight;
}
- (CGFloat)deltaOffsetY{
    _deltaOffsetY = 180;
    return _deltaOffsetY;
}
- (CGFloat)m0{
    _m0 = 1000;
    return _m0;
}
-(CGFloat)n0{
    _n0 = 200;
    return _n0;
}
- (NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [[NSMutableArray alloc]init];
    }
    return _cellArray;
}
- (NSMutableArray *)blurList{
    if (!_blurList) {
        _blurList = [[NSMutableArray alloc]init];
    }
    return _blurList;
}
@end
