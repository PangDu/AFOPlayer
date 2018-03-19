//
//  AFOPLMainCollectionCellDefaultLayout.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^PLMainCellHightBlock)(CGFloat width, NSIndexPath *indexPath);
@interface AFOPLMainCellDefaultLayout : UICollectionViewLayout
@property (nonatomic, copy) PLMainCellHightBlock block;
@end
