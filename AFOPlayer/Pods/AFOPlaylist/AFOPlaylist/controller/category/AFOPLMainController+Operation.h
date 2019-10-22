//
//  AFOPLMainController+Operation.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AFOPLUpdateCollectionViewBlock)(void);
@interface AFOPLMainController (Operation)
@property (nonnull, nonatomic, strong) AFOPLUpdateCollectionViewBlock updateCollectionBlock;
- (void)addOperationButton;
@end
NS_ASSUME_NONNULL_END