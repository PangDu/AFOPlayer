//
//  AFOPLMainCollectionCell.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

typedef void(^userSelectItems)(id model);
@interface AFOPLMainCollectionCell : UICollectionViewCell
@property (nonnull, nonatomic, strong) userSelectItems selectItemBlock;
- (void)settingSubViews:(id)model;
- (void)showDeleteIcon:(BOOL)isShow;
@end
