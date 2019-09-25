//
//  AFOCardPresenterView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFOCardPresenterView : AFOHPPresenter
- (instancetype)initWithDelegate:(id<AFOHPPresenterDelegate>)delegate;
- (void)bindingCollectionView;
@end

NS_ASSUME_NONNULL_END
