//
//  CardStackingViewModel.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "CardStackingViewModel.h"
#import "CardStackingModel.h"

@interface CardStackingViewModel ()
@property (nonatomic, strong) CardStackingModel *model;
@end
@implementation CardStackingViewModel

#pragma mark ------------ custom
- (NSString *)titleIndex:(NSInteger)index{
    return self.model.titleArray[index];
}
- (NSDictionary *)dictionaryIndex:(NSInteger)index{
    NSDictionary *dictionary = @{@"value" : [self titleIndex:index],
                                 @"type" : @(index)
                                 };
    return dictionary;
}
#pragma mark ------------ property
#pragma mark ------ titleArray
- (CardStackingModel *)model{
    if (!_model) {
        _model = [[CardStackingModel alloc] init];
    }
    return _model;
}
@end
