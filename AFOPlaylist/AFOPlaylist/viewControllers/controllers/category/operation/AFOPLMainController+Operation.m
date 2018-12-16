//
//  AFOPLMainController+Operation.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController+Operation.h"
#import "AFOPLMainController+AFOPLMainManager.h"
#import "AFOPLMainManager.h"
#import "AFOPLMainCollectionCell.h"
#import "AFOPLEditMenuView.h"
#import "AFOPLMainManager.h"
@interface AFOPLMainController ()
@property (nonatomic, assign)          BOOL               isEditor;
@property (nonatomic, assign)          BOOL               isTouch;
@property (nonnull, nonatomic, strong) AFOPLEditMenuView *editMenuView;
@end
@implementation AFOPLMainController (Operation)
#pragma mark ------
- (void)setIsEditor:(BOOL)isEditor{
    objc_setAssociatedObject(self, @selector(setIsEditor:), @(isEditor), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isEditor{
    NSNumber *number = objc_getAssociatedObject(self, @selector(setIsEditor:));
    return [number boolValue];
}
- (void)setIsTouch:(BOOL)isTouch{
    objc_setAssociatedObject(self, @selector(setIsTouch:), @(isTouch), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isTouch{
    NSNumber *number = objc_getAssociatedObject(self, @selector(setIsTouch:));
    return [number boolValue];
}
- (void)setUpdateCollectionBlock:(AFOPLUpdateCollectionViewBlock)showButtonBlock{
    objc_setAssociatedObject(self, @selector(setUpdateCollectionBlock:), showButtonBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFOPLUpdateCollectionViewBlock)updateCollectionBlock{
    return objc_getAssociatedObject(self, @selector(setUpdateCollectionBlock:));
}
- (void)setEditMenuView:(AFOPLEditMenuView *)editMenuView{
    objc_setAssociatedObject(self, @selector(setEditMenuView:),editMenuView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFOPLEditMenuView *)editMenuView{
    return objc_getAssociatedObject(self, @selector(setEditMenuView:));
}
#pragma mark ------
- (void)addOperationButton{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorVedioOperation:)];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)editorVedioOperation:(id)sender{
    if (self.dataArray.count < 1) {
        return;
    }
    ///---
    [self addMenuView];
    ///---
    [self userSelectAllItems];
}
- (void)userSelectAllItems{
    WeakObject(self);
    ///--- 全选
    self.editMenuView.allSelectBlock = ^(BOOL isSelected){
        StrongObject(self);
        [self showDeleteIconImageIsAll:isSelected isTouch:!self.isTouch];
        if (isSelected) {
            [self.editMenuView userAllSelectedItems:self.dataArray];
        }else{
            [self.editMenuView userAllSelectedItems:[NSArray array]];
        }
    };
    ///--- 删除
    self.editMenuView.deleteVedioBlock = ^(NSArray * _Nonnull array) {
        StrongObject(self);
        [AFOPLMainManager deleteMovieRelatedContentLocally:array block:^(BOOL isSucess) {
            if (isSucess) {
                [self addCollectionViewData];
                ///
                [UIView animateWithDuration:0.3 animations:^{
                    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
                    self.editMenuView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 40);
                    [self.editMenuView removeUserSelected];
                }];
                self.isEditor = !self.isEditor;
                [self.editMenuView settingButtonTitle];
            }
        }];
    };
    ///---
    [self showDeleteIconImageIsAll:self.isEditor isTouch:self.isTouch];
    self.isTouch = !self.isTouch;
}
- (void)showDeleteIconImageIsAll:(BOOL)isAll
                          isTouch:(BOOL)isTouch{
    [[self.collectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFOPLMainCollectionCell * cell = (AFOPLMainCollectionCell *)[self.collectionView cellForItemAtIndexPath:obj];
        ///---
        [cell showAllDeleteIcon:isAll];
        ///---
        [cell settingCellUnTouch:isTouch];
    }];
}
- (void)addMenuView{
    ///---
    if (!self.editMenuView) {
        self.editMenuView = [[AFOPLEditMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 40) allVedio:self.dataArray.count];
        [self.view addSubview:self.editMenuView];
    }
    ///---
    [UIView animateWithDuration:0.3 animations:^{
        if (!self.isEditor) {
            [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
            self.editMenuView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 90, CGRectGetWidth(self.view.bounds), 40);
        }else{
            [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
            self.editMenuView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 40);
            [self.editMenuView removeUserSelected];
        }
    } completion:^(BOOL finished) {
        self.isEditor = !self.isEditor;
        [self.editMenuView settingButtonTitle];
    }];
}
@end
