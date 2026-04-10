//
//  AFOPLMainController.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface AFOPLMainController : UIViewController
@property (nonatomic, strong, readonly) UICollectionView             *collectionView;
@property (nonatomic, assign) BOOL isInitialized; // 添加标志位
// 新增属性，用于控制导航栏可见性，默认为 YES
@property (nonatomic, assign) BOOL                  prefersNavigationBarHidden;
@end
