//
//  AFOHPPresenterDelegate.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFOHPPresenterDelegate <NSObject>
@optional
- (void)bindingView:(UIView *)view target:(id)target;
- (void)unbundlingView:(UIView *)view;
- (void)bindingController:(UIViewController *)controller target:(id)target;
- (void)unbundlingController:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
