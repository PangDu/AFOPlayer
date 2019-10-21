//
//  AFOHPDetailCell.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPDetailCell.h"
#import <AFOFoundation/AFOFoundation.h>
@interface AFOHPDetailCell ()
@property (nonatomic, strong) UIImageView      *albumImageView;
@property (nonatomic, strong) UILabel          *albumLB;
@property (nonatomic, strong) UILabel          *songLB;
@property (nonatomic, assign, readwrite) CGSize imageSize;
@end

@implementation AFOHPDetailCell

#pragma mark ------------ initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cellAddSubView];
    }
    return self;
}
#pragma mark ------ cellAddSubView
- (void)cellAddSubView{
    ///------ 专辑图
    self.albumImageView.frame = CGRectMake(10, 20, 60, 60);
    [self.contentView addSubview:self.albumImageView];
    _imageSize = CGSizeMake(60, 60);
    ///--- 专辑名
    self.albumLB.frame = CGRectMake(CGRectGetWidth(self.albumImageView.bounds) + 20, 10, 200, 20);
    [self.contentView addSubview:self.albumLB];
    ///--- 歌曲名
    self.songLB.frame = CGRectMake(CGRectGetWidth(self.albumImageView.bounds) +20, CGRectGetHeight(self.albumLB.frame) + 20, 200, CGRectGetHeight(self.bounds));
    [self.contentView addSubview:self.songLB];
    ///---
    WeakObject(self);
    self.block = ^(NSString *albumTitle,
                   NSString *title,
                   UIImage *image,
                   NSInteger type) {
        StrongObject(self);
        if (type == 2) {
            self.albumLB.hidden = YES;
            self.songLB.textAlignment = NSTextAlignmentCenter;
        }
        self.albumLB.text = albumTitle;
        self.songLB.text  = title;
        ///------ 专辑图片
        if (!image) {
            self.albumImageView.image = [UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_album.jpeg"]];
        }else{
            self.albumImageView.image = image;
        }
    };
}
#pragma mark ------------ property
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc]init];
        _albumImageView.layer.cornerRadius = 5;
        _albumImageView.layer.masksToBounds = YES;
    }
    return _albumImageView;
}
- (UILabel *)albumLB{
    if (!_albumLB) {
        _albumLB = [[UILabel alloc] init];
        _albumLB.font = [UIFont systemFontOfSize:18];
    }
    return _albumLB;
}
- (UILabel *)songLB{
    if (!_songLB) {
        _songLB = [[UILabel alloc] init];
        _songLB.font = [UIFont systemFontOfSize:16];
    }
    return _songLB;
}
@end
