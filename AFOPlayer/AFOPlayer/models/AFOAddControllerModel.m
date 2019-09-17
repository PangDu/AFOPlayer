//
//  AFOAppWindowViewModel.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOAddControllerModel.h"
@interface AFOAddControllerModel ()
/**
 首页
 */
@property (nullable, nonatomic, strong) AFOHPForeign *hpPublicController;
///**
// 播放列表
// */
//@property (nullable, nonatomic, strong) AFOPlayListForeign *playListForeign;
@end
@implementation AFOAddControllerModel
#pragma mark ------ 初始化
- (void)controllerInitialization:(AFOAppTabBarController *)tabBarController{
    UIViewController *homePage = [self.hpPublicController returnHPController];
//    UIViewController *playList = [self.playListForeign returnPlayListController];
    [tabBarController setViewControllers:@[homePage]];
}
#pragma mark ------ property
- (AFOHPForeign *)hpPublicController{
    if (!_hpPublicController) {
        _hpPublicController = [[AFOHPForeign alloc]init];
    }
    return _hpPublicController;
}
//- (AFOPlayListForeign *)playListForeign{
//    if (!_playListForeign) {
//        _playListForeign = [[AFOPlayListForeign alloc]init];
//    }
//    return _playListForeign;
//}
@end
