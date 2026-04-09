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
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString *obj in self.controllerArray) {
        Class class = NSClassFromString(obj);
        if (class) {
            id controller = [[class alloc] init];
            if ([controller respondsToSelector:@selector(returnController)]) {
                id show = [controller performSelector:@selector(returnController)];
                [array addObject:show];
            }
        }
    }
    tabBarController.viewControllers = array;
}
#pragma mark ------ property
- (NSArray *)controllerArray{
//    if (!_controllerArray) {
//        _controllerArray = @[@"AFOHPForeign",
//                             @"AFOPlayListForeign"];
//    }
    if (!_controllerArray) {
        _controllerArray = @[@"AFOPLMainController"];
    }
    return _controllerArray;
}
@end
