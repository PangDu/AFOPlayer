//
//  AFOTreeViewRooter.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/15.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOTreeViewRooter.h"


@implementation AFOTreeViewRooter


#pragma mark ------------ 属性
#pragma mark ------ backImageView
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _backImageView;
}
#pragma mark ------ iconImageView
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
#pragma mark ------ titleLB
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc]init];
    }
    return _titleLB;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
