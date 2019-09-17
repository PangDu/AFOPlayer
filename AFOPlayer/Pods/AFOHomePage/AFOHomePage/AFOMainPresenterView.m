//
//  AFOMainPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOMainPresenterView.h"
#import "AFOCardStackingController.h"
@interface AFOMainPresenterView ()
@property (nonatomic, strong) AFOCardStackingController *cardStacking;
@end
@implementation AFOMainPresenterView
- (void)bindingCardStacking{
    [self.presenterDelegate bindingController:self.cardStacking];
}
#pragma mark ------ property
- (AFOCardStackingController *)cardStacking{
    if (!_cardStacking) {
        _cardStacking = [[AFOCardStackingController alloc]init];
    }
    return _cardStacking;
}
@end
