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
/**
 播放列表
 */
@property (nullable, nonatomic, strong) AFOPlayListForeign *playListForeign;
/**
设置
 */
@property (nullable, nonatomic, strong) AFOSettingForeign *settingPublicController;
@end
@implementation AFOAddControllerModel
#pragma mark ------ 初始化
- (void)controllerInitialization:(AFOAppTabBarController *)tabBarController{
    UIViewController *homePage = [self.hpPublicController returnHPController];
    UIViewController *playList = [self.playListForeign returnPlayListController];
    UIViewController *setting = [self.settingPublicController returnSettingController];
    [tabBarController setViewControllers:@[homePage,playList,setting]];
}
#pragma mark ------ property
- (AFOHPForeign *)hpPublicController{
    if (!_hpPublicController) {
        _hpPublicController = [[AFOHPForeign alloc]init];
    }
    return _hpPublicController;
}
- (AFOPlayListForeign *)playListForeign{
    if (!_playListForeign) {
        _playListForeign = [[AFOPlayListForeign alloc]init];
    }
    return _playListForeign;
}
- (AFOSettingForeign *)settingPublicController{
    if (!_settingPublicController) {
        _settingPublicController = [[AFOSettingForeign alloc]init];
    }
    return _settingPublicController;
}
@end
