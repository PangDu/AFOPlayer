//
//  AFOAppWindowViewModel.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAddControllerModel.h"
@interface AFOAddControllerModel ()

@property (nullable, nonatomic, strong) NSArray<NSString *> *controllerArray;
@end
@implementation AFOAddControllerModel
#pragma mark ------ 初始化
- (void)controllerInitialization:(AFOAppTabBarController *)tabBarController{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [self.controllerArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class class = NSClassFromString(obj);
        id controller = [[class alloc] init];
        if ([controller respondsToSelector:@selector(returnController)]) {
                id show   = [controller performSelector:@selector(returnController)];
            [array addObjectAFOAbnormal:show];
        }
    }];
    [tabBarController setViewControllers:array];
}
#pragma mark ------ property
- (NSArray *)controllerArray{
    if (!_controllerArray) {
        _controllerArray = @[@"AFOHPForeign",
                             @"AFOPlayListForeign"];
    }
    return _controllerArray;
}
@end
