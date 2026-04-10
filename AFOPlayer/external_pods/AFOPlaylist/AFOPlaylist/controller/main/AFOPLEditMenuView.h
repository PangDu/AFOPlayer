//
//  AFOPLEditMenuView.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/14.
//  Copyright © 2018 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 <#Description#>

 @param isSelected <#isSelected description#>
 */
typedef void(^editMenuViewALLBlock)(BOOL isSelected);

/**
 <#Description#>

 @param array <#array description#>
 */
typedef void(^editMenuViewDeleteVediosBlock)(NSArray *array);

/**
 <#Description#>
 */
typedef void(^editMenuViewDefaultBlock)(void);
@interface AFOPLEditMenuView : UIView
@property (nonnull, nonatomic, strong) editMenuViewALLBlock allSelectBlock;
@property (nonnull, nonatomic, strong) editMenuViewDeleteVediosBlock deleteVedioBlock;
@property (nonnull, nonatomic, strong) editMenuViewDefaultBlock defaultBlock;
- (instancetype)initWithFrame:(CGRect)frame
                     allVedio:(NSInteger)number;
- (void)settingButtonTitle;
- (void)userAllSelectedItems:(NSArray*)vedeoArray;
- (void)removeUserSelected;
- (void)settingDataCount;
@end

NS_ASSUME_NONNULL_END
