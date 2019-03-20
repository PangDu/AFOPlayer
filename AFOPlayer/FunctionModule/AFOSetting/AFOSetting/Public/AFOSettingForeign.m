//
//  AFOSettingPublicController.m
//  AFOSetting
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOSettingForeign.h"
@interface AFOSettingForeign ()
@property (nonatomic, strong) AFOSettingNavigationController *navigationController;
@property (nonatomic, strong) AFOSettingMainController       *mainController;

@end

@implementation AFOSettingForeign

#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ 自定义
- (UIViewController *)returnSettingController{
    return self.navigationController;
}
#pragma mark ------------ 系统
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ 属性
#pragma mark ------ mainController
- (AFOSettingMainController *)mainController{
    if (!_mainController) {
        _mainController = [[AFOSettingMainController alloc]init];
    }
    return _mainController;
}
#pragma mark ------ navigationController
- (AFOSettingNavigationController *)navigationController{
    if (!_navigationController) {
        _navigationController = [[AFOSettingNavigationController alloc]initWithRootViewController:self.mainController];
    }
    return _navigationController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
