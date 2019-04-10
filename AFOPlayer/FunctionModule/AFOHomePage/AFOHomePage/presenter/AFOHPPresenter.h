//
//  AFOHPPresenter.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOHPPresenterDelegate.h"
NS_ASSUME_NONNULL_BEGIN
@interface AFOHPPresenter  : NSObject <AFOHPPresenterDelegate>
@property (nonatomic, strong, readonly) UIView            *presenterView;
@property (nonatomic, strong, readonly) UIViewController  *controller;
@property (nonatomic, weak, readonly) id<AFOHPPresenterDelegate>presenterDelegate;
- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithController:(UIViewController *)controller;
- (instancetype)initWithDelegate:(id<AFOHPPresenterDelegate>)delegate;
- (id)delegateTarget;
- (id)dataSourceTarget;
@end

NS_ASSUME_NONNULL_END
