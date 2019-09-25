//
//  AFOHPPlayPresenterView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"
#import "AFOHPPlayPresenterViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@interface AFOHPPlayPresenterView : AFOHPPresenter
- (instancetype)initWithDelegate:(id<AFOHPPlayPresenterViewDelegate>)delegate;
- (void)bindingPlayerView;
- (void)setttingPlayTimer:(NSTimeInterval)currentTime
                totalTime:(NSTimeInterval)totalTime;
- (void)settingTotalTime:(NSString *)totalTime;
@end

NS_ASSUME_NONNULL_END
