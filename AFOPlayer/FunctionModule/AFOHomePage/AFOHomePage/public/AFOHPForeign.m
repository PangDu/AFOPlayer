//
//  AFOHPPublicController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPForeign.h"

@interface AFOHPForeign ()
@property (nonatomic, strong) AFOHPNavigationController *navigationController;
@property (nonatomic, strong) AFOHPMainController       *mainController;
@end

@implementation AFOHPForeign
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ 自定义方法
#pragma mark ------ 首页界面
- (UIViewController *)returnHPController{
    return self.navigationController;
}
#pragma mark ------------ 系统方法

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ 属性
#pragma mark ------ mainController
- (AFOHPMainController *)mainController{
    if (!_mainController) {
        _mainController = [[AFOHPMainController alloc]init];
    }
    return _mainController;
}
#pragma mark ------ navigationController
- (AFOHPNavigationController *)navigationController{
    if (!_navigationController) {
        _navigationController = [[AFOHPNavigationController alloc]initWithRootViewController:self.mainController];
    }
    return _navigationController;
}
@end
