//
//  AFOPLMainCollectionCell.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface AFOPLMainCollectionCell : UICollectionViewCell
- (void)settingSubViews:(id)model;
- (void)settingCellUnTouch:(BOOL)isTouch;
- (void)showAllDeleteIcon:(BOOL)isShow;
@end
