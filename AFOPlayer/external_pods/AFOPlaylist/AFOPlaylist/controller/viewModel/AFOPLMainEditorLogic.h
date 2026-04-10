//
//  AFOPLMainEditorLogic.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2026/4/9.
//  Copyright © 2026年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFOPLEditMenuView.h"

@class AFOPLMainController;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AFOPLUpdateCollectionViewBlock)(void);

@interface AFOPLMainEditorLogic : NSObject

@property (nonatomic, weak, readonly) AFOPLMainController *mainController;

@property (nonatomic, assign)          BOOL               isEditor;
@property (nonatomic, assign)          BOOL               isTouch;
@property (nonnull, nonatomic, strong) AFOPLEditMenuView *editMenuView;
@property (nonnull, nonatomic, strong) AFOPLUpdateCollectionViewBlock updateCollectionBlock;

- (instancetype)initWithMainController:(AFOPLMainController *)mainController;

- (void)setupEditButton;
- (void)editorVedioOperation:(id)sender;
- (void)addMenuView;
- (void)userSelectAllItems;
- (void)showDeleteIconImageIsAll:(BOOL)isShow
                          isTouch:(BOOL)isTouch;

@end

NS_ASSUME_NONNULL_END