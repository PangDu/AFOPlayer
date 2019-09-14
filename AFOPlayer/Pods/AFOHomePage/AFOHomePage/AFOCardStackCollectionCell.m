//
//  AFOCardStackCollectionCell.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOCardStackCollectionCell.h"
@interface AFOCardStackCollectionCell ()
@property (nonatomic, strong) UILabel       *titleLB;
@property (nonatomic, strong) UIImageView   *backImageView;
@end

@implementation AFOCardStackCollectionCell
#pragma mark ------------ settingTitle
- (void)settingTitle:(NSString *)title image:(NSString *)name{
    self.backImageView.image = [UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:name]];
    [self.contentView addSubview:self.backImageView];
    ///---
    self.titleLB.text = title;
    [self.contentView addSubview:self.titleLB];
}
#pragma mark ------------ property
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        _titleLB.center = self.contentView.center;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.font = [UIFont systemFontOfSize:25];
    }
    return _titleLB;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
@end
