//
//  CardStackingModel.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "CardStackingModel.h"

@interface CardStackingModel ()
@property (nonatomic, copy) NSArray *titleArray;
@end
@implementation CardStackingModel
#pragma mark ------------ property
#pragma mark ------ titleArray
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"艺术家",@"专辑",@"所有音乐",@"播放列表"];
    }
    return _titleArray;
}
@end
