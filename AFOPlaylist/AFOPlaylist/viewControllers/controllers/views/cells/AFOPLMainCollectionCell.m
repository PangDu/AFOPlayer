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
@property (nonatomic, assign)          BOOL         isTouch;
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
    self.isTouch = YES;
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
    NSDictionary *dictionary = nil;
    if (button.selected) {
        dictionary = @{@"operation" : @"add",
                       @"value" : self.models
                       };
    }else{
        dictionary = @{@"operation" : @"remove",
                       @"value" : self.models
                       };
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOPLEditMenuViewNotification" object:nil userInfo:dictionary ];
}
- (void)showAllDeleteIcon:(BOOL)isShow{
    self.isShow = isShow;
    ///---
    self.isTouch = isShow;
    self.deleteButton.hidden = !isShow;
    self.deleteButton.selected = isShow;
}
- (void)settingCellUnTouch:(BOOL)isShow{
    self.isTouch = isShow;
    self.deleteButton.hidden = isShow;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isTouch) {
        [super touchesBegan:touches withEvent:event];
    }else{
        [[self nextResponder] touchesBegan:touches withEvent:event];
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
