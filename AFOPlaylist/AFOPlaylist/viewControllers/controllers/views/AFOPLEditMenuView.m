//
//  AFOPLEditMenuView.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/14.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLEditMenuView.h"

#define AFOPLEditMenuViewDeleteAllItem @"确认删除全部影片!"

@interface AFOPLEditMenuView ()<UIAlertViewDelegate>
@property (nonnull, nonatomic, strong) UIButton         *allSelectBT;
@property (nonnull, nonatomic, strong) UIButton         *deleteBT;
@property (nonnull, nonatomic, strong) NSMutableArray   *selectArray;
@property (nonatomic, assign)          NSInteger         allVedioNumber;
@end

@implementation AFOPLEditMenuView
- (instancetype)initWithFrame:(CGRect)frame
                     allVedio:(NSInteger)number{
    if (self = [super initWithFrame:frame]) {
        _allVedioNumber = number;
        [self addSubViews:frame];
    }
    return self;
}
- (void)addSubViews:(CGRect)frame{
    ///---
    self.allSelectBT.backgroundColor = [UIColor redColor];
    self.allSelectBT.frame = CGRectMake(0, 0,CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds));
    [self addSubview:self.allSelectBT];
    ///---
    self.deleteBT.backgroundColor = [UIColor orangeColor];
    self.deleteBT.frame = CGRectMake(CGRectGetWidth(self.bounds)/2, 0, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds));
    [self addSubview:self.deleteBT];
    ///---
    [INTUAutoRemoveObserver addObserver:self selector:@selector(userSelectVedioItem:) name:@"AFOPLEditMenuViewNotification" object:nil];
}
- (void)userSelectVedioItem:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"AFOPLEditMenuViewNotification"]) {
        NSDictionary *dictionary = notification.userInfo;
        NSString *strOperation = [dictionary objectForKey:@"operation"];
        id model = [dictionary objectForKey:@"value"];
        if (model && [strOperation isEqualToString:@"add"]) {
            [self.selectArray addObject:model];
        }else if(model && [strOperation isEqualToString:@"remove"]){
            [self.selectArray removeObject:model];
        }
        [self showDeleteItemsCount:self.selectArray.count];
    }
}
- (void)removeUserSelected{
    [self.selectArray removeAllObjects];
}
#pragma mark ------
- (void)selectAllItem:(id)sender{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    ///---
    if (!button.selected) {
        [self settingButtonTitle];
    }
    ///---
    self.allSelectBlock(button.selected);
}
- (void)settingButtonTitle{
    self.deleteBT.selected = NO;
    self.allSelectBT.selected = NO;
}
- (void)userAllSelectedItems:(NSArray *)vedeoArray{
    if (!vedeoArray || vedeoArray.count == 0) {
        self.deleteBT.selected = NO;
        return;
    }
    [self.selectArray removeAllObjects];
    [self.selectArray addObjectsFromArray:vedeoArray];
    [self showDeleteItemsCount:self.selectArray.count];
}
#pragma mark ------ 删除视频
- (void)deleteVedioItem:(id)sender{
    if (self.selectArray.count < 1) {
        return;
    }
    ///---
    [self settingDefaultState];
    ///---
    [self showAlertView];
}
- (void)showAlertView{
    NSString *strMessage = @"确定删除全部文件吗？";
    if (self.selectArray.count < self.allVedioNumber) {
        strMessage = [NSString stringWithFormat:@"确认删除%lu个文件吗？",(unsigned long)self.selectArray.count];
    }
    ///---
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:strMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
- (void)showDeleteItemsCount:(NSInteger)vedioCount{
    if (vedioCount == 0) {
        self.deleteBT.selected = NO;
        return;
    }
    self.deleteBT.selected = YES;
    NSString *string = [NSString stringWithFormat:@"删除(%ld)",(long)vedioCount];
    [self.deleteBT setTitle:string forState:UIControlStateSelected];
    ///---
    if (self.selectArray.count == self.allVedioNumber) {
        self.allSelectBT.selected = YES;
    }else{
        self.allSelectBT.selected = NO;
    }
}
- (void)settingDataCount{
    self.allVedioNumber -= self.selectArray.count;
}
- (void)settingDefaultState{
    [self settingButtonTitle];
    self.defaultBlock();
    self.frame = CGRectMake(0, AFO_SCREEN_HEIGHT, AFO_SCREEN_WIDTH, 40);
}
#pragma mark ------ delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        self.deleteVedioBlock(self.selectArray);
    }
}
#pragma mark ------ attribute
- (UIButton *)allSelectBT{
    if (!_allSelectBT) {
        _allSelectBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectBT setTitle:@"全选" forState:(UIControlStateNormal)];
        [_allSelectBT setTitle:@"取消全选" forState:UIControlStateSelected];
        [_allSelectBT addTarget:self action:@selector(selectAllItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allSelectBT;
}
- (UIButton *)deleteBT{
    if (!_deleteBT) {
        _deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBT setTitle:@"删除" forState:(UIControlStateNormal)];
        [_deleteBT setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_deleteBT setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_deleteBT addTarget:self action:@selector(deleteVedioItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBT;
}
- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [[NSMutableArray alloc] init];
    }
    return _selectArray;
}
@end
