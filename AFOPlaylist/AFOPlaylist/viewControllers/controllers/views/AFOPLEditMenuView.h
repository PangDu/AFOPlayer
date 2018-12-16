//
//  AFOPLEditMenuView.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/14.
//  Copyright © 2018 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^editMenuViewALLBlock)(BOOL isSelected);
typedef void(^editMenuViewDeleteVediosBlock)(NSArray *array);
@interface AFOPLEditMenuView : UIView
@property (nonnull, nonatomic, strong) editMenuViewALLBlock allSelectBlock;
@property (nonnull, nonatomic, strong) editMenuViewDeleteVediosBlock deleteVedioBlock;
- (instancetype)initWithFrame:(CGRect)frame
                     allVedio:(NSInteger)number;
- (void)settingButtonTitle;
- (void)userAllSelectedItems:(NSArray*)vedeoArray;
- (void)removeUserSelected;
@end

NS_ASSUME_NONNULL_END
