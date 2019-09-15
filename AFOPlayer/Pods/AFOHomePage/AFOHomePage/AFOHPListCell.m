//
//  AFOHPListCell.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/27.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListCell.h"
#import <AFOFoundation/AFOFoundation.h>
@interface AFOHPListCell ()
@property (nonatomic, assign, readwrite) CGSize     imageSize;
@property (nonatomic, strong) UIImageView          *albumImageView;
@property (nonatomic, strong) UILabel              *titleLB;
@end
@implementation AFOHPListCell

#pragma mark ------ initWithStyle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cellAddSubviews];
    }
    return self;
}
#pragma mark ------------ cellAddSubviews
- (void)cellAddSubviews{
    ///----
    self.albumImageView.frame =CGRectMake(0, 0, 80, 80);
    [self.contentView addSubview:self.albumImageView];
    ///----
    self.titleLB.frame =CGRectMake(CGRectGetWidth(self.albumImageView.frame) + 20, 40, 200, 20);
    [self.contentView addSubview:self.titleLB];
    ///---
    WeakObject(self);
    self.block = ^(NSString *title, NSString *artists, UIImage *image, NSInteger type) {
        StrongObject(self);
        if (type == 1) {
            self.textLabel.text = artists;
            self.albumImageView.hidden = YES;
            self.titleLB.hidden = YES;
        }else{
            self.titleLB.text = title;
            if (!image) {
                self.albumImageView.image = [UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_album.jpeg"]];
            }else{
                self.albumImageView.image = image;
            }
        }
    };
}
#pragma mark ------------ property
- (UIImageView *)albumImageView{
    if (!_albumImageView) {
        _albumImageView = [[UIImageView alloc] init];
    }
    return _albumImageView;
}
- (UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:18];
    }
    return _titleLB;
}
@end
