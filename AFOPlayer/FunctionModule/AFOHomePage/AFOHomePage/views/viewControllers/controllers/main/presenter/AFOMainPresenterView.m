//
//  AFOMainPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOMainPresenterView.h"
@interface AFOMainPresenterView ()
@property (nonatomic, strong) AFOCardStackingController *cardStacking;
@property (nonatomic, weak) id<AFOHPPresenterDelegate>   delegate;
@end
@implementation AFOMainPresenterView
- (instancetype)initWithDelegate:(id<AFOHPPresenterDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}
- (void)bindingCardStacking{
    [self.delegate bindingController:self.cardStacking];
}
#pragma mark ------ property
- (AFOCardStackingController *)cardStacking{
    if (!_cardStacking) {
        _cardStacking = [[AFOCardStackingController alloc]init];
    }
    return _cardStacking;
}
@end
