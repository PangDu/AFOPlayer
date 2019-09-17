//
//  AFOHPPlayPresenterViewDelegate.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFOHPPlayPresenterViewDelegate <AFOHPPresenterDelegate>
@optional
- (void)musicPlayActionDelegate:(BOOL)isPlay;
- (void)updateProgressSliderDelegate;
@end

NS_ASSUME_NONNULL_END
