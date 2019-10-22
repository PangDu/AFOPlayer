//
//  AFOHPPlayPresenterBusiness.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"
#import "AFOHPPlayPresenterBusinessDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface AFOHPPlayPresenterBusiness : AFOHPPresenter
- (instancetype)initWithDelegate:(id<AFOHPPlayPresenterBusinessDelegate>)delegate;
- (void)receiverRouterMessage:(id)model
                   parameters:(NSDictionary *)parameters;
- (void)musicPlayAction:(BOOL)isPlay;
- (void)musicPlayTimerCallBack:(void(^)(NSTimeInterval currentTime,
                                        NSTimeInterval totalTime))block;
@end

NS_ASSUME_NONNULL_END
