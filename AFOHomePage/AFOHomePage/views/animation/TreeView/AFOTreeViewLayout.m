//
//  AFOTreeViewLayout.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/15.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOTreeViewLayout.h"
#import "AFOTreeView.h"
#import "AFOTreeViewCenter.h"
#import "AFOTreeViewAround.h"

@implementation AFOTreeViewLayoutPoint
- (instancetype)init{
    if (self = [super init]) {
        _nearDistance = 30;
        _farDistance = 60;
        _endDistance = 30;
    }
    return self;
}
@end

@interface AFOTreeViewLayout ()
@property (nonatomic, assign) CGPoint         defaultPoint;
@property (nonatomic, strong) NSMutableArray *pointArray;
@end

@implementation AFOTreeViewLayout

#pragma mark ------------ 自定义
#pragma mark ------ 设置小图位置
- (void)settingAroundView:(id)aroundView
                 treeView:(id)treeView
                   layout:(id)layout
                    index:(NSInteger)index{
    //------------
    AFOTreeViewLayout *viewLayout = layout;
    AFOTreeViewAround *around  = aroundView;
    AFOTreeView *tree = treeView;
    self.defaultPoint = CGPointMake(tree.frame.size.width/2, tree.frame.size.height/2);
    //------------
    AFOTreeViewLayoutPoint *layoutPoint = [[AFOTreeViewLayoutPoint alloc]init];
    CGFloat pi =  M_PI / viewLayout.count;
    CGFloat endRadius = around.bounds.size.width / 2 + layoutPoint.endDistance + around.bounds.size.width / 2;
    CGFloat nearRadius = around.bounds.size.width / 2 + layoutPoint.nearDistance + (1.5 * around.bounds.size.width) / 2;
    CGFloat farRadius = around.bounds.size.width / 2 + layoutPoint.farDistance + (1.5 * around.bounds.size.width) / 2;
    
    layoutPoint.startPoint = self.defaultPoint;
    layoutPoint.endPoint = CGPointMake(self.defaultPoint.x + endRadius * sinf(pi * index),
                                       self.defaultPoint.y - endRadius * cosf(pi * index));
    layoutPoint.nearPoint = CGPointMake(self.defaultPoint.x + nearRadius * sinf(pi * index),
                                        self.defaultPoint.y - nearRadius * cosf(pi * index));
    layoutPoint.farPoint = CGPointMake(self.defaultPoint.x + farRadius * sinf(pi * index),
                                       self.defaultPoint.y - farRadius * cosf(pi * index));
    around.center = layoutPoint.startPoint;
    [self.pointArray addObject:layoutPoint];
}
#pragma mark ------------ 属性
#pragma mark ------ pointArray
- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [[NSMutableArray alloc]init];
    }
    return _pointArray;
}
#pragma mark ------ imageArray
- (NSArray *)imageArray{
    if (!_imageArray ) {
        _imageArray = [[NSArray alloc]init];
    }
    return _imageArray;
}
#pragma mark ------ titleArray
- (NSArray *)titleArray{
    if (!_imageArray ) {
        _imageArray = [[NSArray alloc]init];
    }
    return _imageArray;
}
@end
