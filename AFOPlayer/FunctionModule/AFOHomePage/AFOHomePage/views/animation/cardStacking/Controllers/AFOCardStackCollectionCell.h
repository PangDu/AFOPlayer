//
//  AFOCardStackCollectionCell.h
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFOCardStackCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLB;
- (void)settingCellControl:(NSIndexPath *)indexPath;
@end
