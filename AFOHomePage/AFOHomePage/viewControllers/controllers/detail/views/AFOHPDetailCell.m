//
//  AFOHPDetailCell.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPDetailCell.h"
#import "AFOHPDetailViewModel.h"

@interface AFOHPDetailCell ()
@property (nonatomic , assign) NSInteger   type;
@property (nonatomic, strong) UIImageView *albumImageView;
@property (nonatomic, strong) UILabel     *albumLB;
@property (nonatomic, strong) UILabel     *songLB;
@end

@implementation AFOHPDetailCell

#pragma mark ------------ init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cellAddSubView];
    }
    return self;
}
#pragma mark ------ 添加控件
- (void)cellAddSubView{
    ///------ 专辑图
    self.albumImageView.frame = CGRectMake(10, 20, 60, 60);
    [self.contentView addSubview:self.albumImageView];
    ///------ 专辑名
    self.albumLB.frame = CGRectMake(CGRectGetWidth(self.albumImageView.bounds) + 20, 10, 200, 20);
    [self.contentView addSubview:self.albumLB];
    ///------ 歌曲名
    self.songLB.frame = CGRectMake(CGRectGetWidth(self.albumImageView.bounds) +20, CGRectGetHeight(self.albumLB.frame) + 20, 200, CGRectGetHeight(self.bounds));
    [self.contentView addSubview:self.songLB];
}
#pragma mark ------ 控件赋值
- (void)settingSubViews:(id)object type:(NSInteger)type{
    self.type = type;
    if (self.type == 2) {
        self.albumLB.hidden = YES;
        self.songLB.textAlignment = NSTextAlignmentCenter;
    }
      __weak typeof(self) weakSelf = self;
    [AFOHPDetailViewModel songsDetails:object block:^(NSDictionary *dictionary) {
        weakSelf.albumLB.text = dictionary[@"albumTitle"];
        weakSelf.songLB.text  = dictionary[@"title"];
    }];
    ///------ 专辑图片
    self.albumImageView.image = [AFOHPDetailViewModel albumImageWithSize:CGSizeMake(CGRectGetWidth(self.albumImageView.frame), CGRectGetHeight(self.albumImageView.frame)) object:object];
}
#pragma mark ------------ property
#pragma mark ------ albumImageView
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]init];
        _albumImageView.layer.cornerRadius = 5;
        _albumImageView.layer.masksToBounds = YES;
    }
    return _albumImageView;
}
#pragma mark ------ albumLB
- (UILabel *)albumLB{
    if (!_albumLB) {
        _albumLB = [[UILabel alloc] init];
        _albumLB.font = [UIFont systemFontOfSize:18];
    }
    return _albumLB;
}
#pragma mark ------ songLB
- (UILabel *)songLB{
    if (!_songLB) {
        _songLB = [[UILabel alloc] init];
        _songLB.font = [UIFont systemFontOfSize:16];
    }
    return _songLB;
}
@end
