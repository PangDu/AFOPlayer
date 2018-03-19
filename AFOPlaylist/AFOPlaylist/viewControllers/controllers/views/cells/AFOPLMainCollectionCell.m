//
//  AFOPlayListMainCollectionCell.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainCollectionCell.h"
#import "AFOPLMainFolderManager.h"
#import "AFOPLThumbnail.h"
@interface AFOPLMainCollectionCell ()
@property (nonatomic, strong) UIImageView *postersImageView;
@property (nonatomic, strong) UILabel     *postersLB;
@end
@implementation AFOPLMainCollectionCell
#pragma mark ------------ initWithFrame
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self cellAddSubview:frame];
    }
    return self;
}
#pragma mark ------ addSubview
- (void)cellAddSubview:(CGRect)frame{
    self.contentView.backgroundColor = [UIColor whiteColor];
    ///------
    self.postersImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 20);
    [self.contentView addSubview:self.postersImageView];
    ///------
    self.postersLB.frame = CGRectMake(0, CGRectGetHeight(self.postersImageView.frame), frame.size.width, CGRectGetHeight(frame) - CGRectGetHeight(self.postersImageView.frame));
    [self.contentView addSubview:self.postersLB];
}
#pragma mark ------ 设置文字、图片
- (void)settingSubViews:(id)model{
    AFOPLThumbnail *detail = model;
    NSString *path =[[AFOPLMainFolderManager mediaImagesCacheFolder] stringByAppendingString:@"/"];
    NSURL *imageUrl = [NSURL fileURLWithPath:[path stringByAppendingString:detail.image_name]];
    [self.postersImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"back.jpg"]];
}
#pragma mark ------------ property
#pragma mark ------ postersImageView
- (UIImageView *)postersImageView{
    if (!_postersImageView) {
        _postersImageView = [[UIImageView alloc] init];
    }
    return _postersImageView;
}
#pragma mark ------ postersLB
- (UILabel *)postersLB{
    if (!_postersLB) {
        _postersLB = [[UILabel alloc] init];
    }
    return _postersLB;
}
@end
