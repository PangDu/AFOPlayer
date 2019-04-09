//
//  AFOHPPresenter.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"
@interface AFOHPPresenter ()
@property (nonatomic, strong, readwrite) UIView            *presenterView;
@property (nonatomic, strong, readwrite) UIViewController  *controller;
@end

@implementation AFOHPPresenter
#pragma mark ------ initWithView
- (instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        _presenterView = view;
    }
    return self;
}
#pragma mark ------ initWithController
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        _controller = controller;
    }
    return self;
}
- (id)delegateTarget{
    return nil;
}
- (id)dataSourceTarget{
    return nil;
}
@end
