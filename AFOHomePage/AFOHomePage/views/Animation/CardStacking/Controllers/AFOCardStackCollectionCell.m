//
//  AFOCardStackCollectionCell.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOCardStackCollectionCell.h"
#import "CardStackingViewModel.h"
@interface AFOCardStackCollectionCell ()
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, copy)   CardStackingViewModel *viewModel;
@end

@implementation AFOCardStackCollectionCell
#pragma mark ------------ 自定义
- (void)settingCellControl:(NSIndexPath *)indexPath{
    //------ title
    self.titleLB.text = [self.viewModel titleIndex:indexPath.row];
    //------ addSubview
    [self.contentView addSubview:self.rightLB];
    [self.contentView addSubview:self.titleLB];
}
#pragma mark ------ 旋转
#pragma mark ------------ 属性
#pragma mark ------ rightLB
- (UILabel *)rightLB{
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 100, 33, 120, 20)];
        _rightLB.textAlignment = NSTextAlignmentCenter;
        _rightLB.text = @"iPod媒体库";
        _rightLB.font = [UIFont systemFontOfSize:18];
        _rightLB.transform=CGAffineTransformMakeRotation(M_PI_4);
    }
    return _rightLB;
}
#pragma mark ------ titleLB
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _titleLB.center = self.contentView.center;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:20];
    }
    return _titleLB;
}
#pragma mark ------------ 属性
- (CardStackingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CardStackingViewModel alloc]init];
    }
    return _viewModel;
}
@end
