//
//  AFOPLMainEditorLogic.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2026/4/9.
//  Copyright © 2026年 AFO. All rights reserved.
//

#import "AFOPLMainEditorLogic.h"
#import "AFOPLMainController.h"
#import "AFOPLEditMenuView.h"
#import "AFOPLMainManager.h"
#import "AFOPLMainCollectionCell.h"

@interface AFOPLMainEditorLogic ()

@property (nonatomic, weak, readwrite) AFOPLMainController *mainController;

@end

@implementation AFOPLMainEditorLogic

- (instancetype)initWithMainController:(AFOPLMainController *)mainController {
    self = [super init];
    if (self) {
        _mainController = mainController;
    }
    return self;
}

#pragma mark - Setup Edit Button

- (void)setupEditButton {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editorVedioOperation:)];
    self.mainController.navigationItem.rightBarButtonItem = backItem;
}

#pragma mark - Editor Operations

- (void)editorVedioOperation:(id)sender {
    // TODO: self.mainController.dataArray.count 需要从主控制器获取
    if (0 < 1) { // 暂时用 0 < 1 代替 dataArray.count
        return;
    }
    [self addMenuView];
    [self userSelectAllItems];
}

- (void)addMenuView {
    if (!self.editMenuView) {
        // TODO: self.mainController.view.bounds 需要从主控制器获取
        self.editMenuView = [[AFOPLEditMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.mainController.view.bounds), CGRectGetWidth(self.mainController.view.bounds), 40) allVedio:0]; // 暂时用 0 代替 dataArray.count
        [self.mainController.view addSubview:self.editMenuView];
    }

    [UIView animateWithDuration:0.3 animations:^{
        if (!self.isEditor) {
            [self.mainController.navigationItem.rightBarButtonItem setTitle:@"取消"];
            // TODO: self.mainController.view.bounds 需要从主控制器获取
            self.editMenuView.frame = CGRectMake(0, CGRectGetHeight(self.mainController.view.bounds) - 90, CGRectGetWidth(self.mainController.view.bounds), 40);
        } else {
            [self.mainController.navigationItem.rightBarButtonItem setTitle:@"编辑"];
            // TODO: self.mainController.view.bounds 需要从主控制器获取
            self.editMenuView.frame = CGRectMake(0, CGRectGetHeight(self.mainController.view.bounds), CGRectGetWidth(self.mainController.view.bounds), 40);
            [self.editMenuView removeUserSelected];
        }
    } completion:^(BOOL finished) {
        self.isEditor = !self.isEditor;
        [self.editMenuView settingButtonTitle];
    }];
}

- (void)userSelectAllItems {
    [self editMenuViewSelectAll];
    [self editMenuViewDelete];
    [self editMenuViewDefault];

    // TODO: self.mainController.collectionView 需要从主控制器获取
    [self showDeleteIconImageIsAll:self.isEditor isTouch:self.isTouch];
    self.isTouch = !self.isTouch;
}

#pragma mark - Edit Menu Actions

- (void)editMenuViewSelectAll {
    __weak typeof(self) weakSelf = self;
    self.editMenuView.allSelectBlock = ^(BOOL isSelected) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        // TODO: self.mainController.collectionView 需要从主控制器获取
        // TODO: self.mainController.dataArray 需要从主控制器获取
        [strongSelf showDeleteIconImageIsAll:isSelected isTouch:!self.isTouch];
        if (isSelected) {
            // [self.editMenuView userAllSelectedItems:self.mainController.dataArray]; // TODO: 暂时注释
        } else {
            [self.editMenuView userAllSelectedItems:[NSArray array]];
        }
    };
}

- (void)editMenuViewDelete {
    __weak typeof(self) weakSelf = self;
    self.editMenuView.deleteVedioBlock = ^(NSArray * _Nonnull array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [AFOPLMainManager deleteMovieRelatedContentLocally:array block:^(BOOL isSucess) {
            if (isSucess) {
                self.updateCollectionBlock();
                [self.editMenuView settingDataCount];
            }
        }];
    };
}

- (void)editMenuViewDefault {
    __weak typeof(self) weakSelf = self;
    self.editMenuView.defaultBlock = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [self.mainController.navigationItem.rightBarButtonItem setTitle:@"编辑"];
        // TODO: self.mainController.collectionView 需要从主控制器获取
        [self showDeleteIconImageIsAll:!self.isEditor isTouch:self.isTouch];
        self.isTouch = NO;
        self.isEditor = NO;
    };
}

- (void)showDeleteIconImageIsAll:(BOOL)isShow
                          isTouch:(BOOL)isTouch {
    // TODO: self.mainController.collectionView 需要从主控制器获取
    [[self.mainController.collectionView indexPathsForVisibleItems] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFOPLMainCollectionCell * cell = (AFOPLMainCollectionCell *)[self.mainController.collectionView cellForItemAtIndexPath:obj];
        [cell showAllDeleteIcon:isShow];
        [cell settingCellUnTouch:isTouch];
    }];
}

#pragma mark - Accessors

- (void)setIsEditor:(BOOL)isEditor {
    _isEditor = isEditor;
}

- (void)setIsTouch:(BOOL)isTouch {
    _isTouch = isTouch;
}

- (void)setEditMenuView:(AFOPLEditMenuView *)editMenuView {
    _editMenuView = editMenuView;
}

- (void)setUpdateCollectionBlock:(AFOPLUpdateCollectionViewBlock)updateCollectionBlock {
    _updateCollectionBlock = updateCollectionBlock;
}

@end
