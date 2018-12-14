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
@property (nonnull, nonatomic, strong) UIImageView *postersImageView;
@property (nonnull, nonatomic, strong) UIButton    *deleteButton;
@property (nonnull, nonatomic, strong) UILabel     *postersLB;
@property (nonnull, nonatomic, strong) id           models;
@property (nonatomic, assign)          BOOL         isShow;
@end
@implementation AFOPLMainCollectionCell
#pragma mark ------------ init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self cellAddSubview:frame];
    }
    return self;
}
#pragma mark ------ method
- (void)cellAddSubview:(CGRect)frame{
    self.contentView.backgroundColor = [UIColor whiteColor];
    ///------
    self.postersImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 20);
    [self.contentView addSubview:self.postersImageView];
    ///------
    self.postersLB.frame = CGRectMake(0, CGRectGetHeight(self.postersImageView.frame), frame.size.width, CGRectGetHeight(frame) - CGRectGetHeight(self.postersImageView.frame));
    [self.contentView addSubview:self.postersLB];
    ///------
    self.deleteButton.frame = self.postersImageView.frame;
    self.deleteButton.hidden = YES ;
    self.deleteButton.userInteractionEnabled = NO;
    [self.contentView addSubview:self.deleteButton];
}
#pragma mark ------ 控件赋值
- (void)settingSubViews:(id)model{
    AFOPLThumbnail *detail = model;
    NSString *path =[[AFOPLMainFolderManager mediaImagesCacheFolder] stringByAppendingString:@"/"];
    NSURL *imageUrl = [NSURL fileURLWithPath:[path stringByAppendingString:detail.image_name]];
    [self.postersImageView sd_setImageWithURL:imageUrl];
    self.postersLB.text = detail.vedio_name;
    ///---
    self.models = model;
}
#pragma mark ------
- (void)deleteVedioItem:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        self.selectItemBlock(_models);
    }
}
- (void)showDeleteIcon:(BOOL)isShow{
    self.isShow = isShow;
    ///---
    if (!isShow) {
        self.deleteButton.hidden = !isShow;
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_isShow) {
        [super touchesBegan:touches withEvent:event];
    }else{
        [[self nextResponder] touchesBegan:touches withEvent:event];
        self.deleteButton.hidden = !_isShow;
        self.deleteButton.userInteractionEnabled = _isShow;
        self.deleteButton.selected = _isShow;
    }
}
#pragma mark ------------ property
- (UIImageView *)postersImageView{
    if (!_postersImageView) {
        _postersImageView = [[UIImageView alloc] init];
    }
    return _postersImageView;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:nil forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateSelected];
        [_deleteButton addTarget:self action:@selector(deleteVedioItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UILabel *)postersLB{
    if (!_postersLB) {
        _postersLB = [[UILabel alloc] init];
    }
    return _postersLB;
}
@end
