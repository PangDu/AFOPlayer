//
//  AFOHPListCell.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/27.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListCell.h"
#import "AFOHPListViewModel.h"

@interface AFOHPListCell ()
@property (nonatomic, strong) UIImageView          *albumImageView;
@property (nonatomic, strong) UILabel              *titleLB;
@property (nonatomic, strong) AFOHPListViewModel   *viewModel;
@end
@implementation AFOHPListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cellAddSubviews];
    }
    return self;
}
#pragma mark ------------ custom
- (void)cellAddSubviews{
    ///----
    self.albumImageView.frame =CGRectMake(0, 0, 80, 80);
    [self.contentView addSubview:self.albumImageView];
    ///----
    self.titleLB.frame =CGRectMake(CGRectGetWidth(self.albumImageView.frame) + 20, 40, 200, 20);
    [self.contentView addSubview:self.titleLB];
}
#pragma mark ------ 
- (void)settingSubviewsValue:(id)object type:(NSInteger)type{
    if (type == 1) {
        self.textLabel.text = [AFOHPListViewModel artistsNameObject:object];
        self.albumImageView.hidden = YES;
        self.titleLB.hidden = YES;
    }else{
        __weak typeof(self) weakSelf = self;
        ///------
        [self.viewModel settingAlbumObject:object block:^(NSString *name) {
            weakSelf.titleLB.text = name;
        }];
        ///------
        self.albumImageView.image = [AFOHPListViewModel albumImageWithSize:self.albumImageView.frame.size object:object];
    }
}
#pragma mark ------------ property
#pragma mark ------ imageView
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
    }
    return _albumImageView;
}
#pragma mark ------ titleLB
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:18];
    }
    return _titleLB;
}
#pragma mark ------ viewModel
- (AFOHPListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AFOHPListViewModel alloc] init];
    }
    return _viewModel;
}
@end
