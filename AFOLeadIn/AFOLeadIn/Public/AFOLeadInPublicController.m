//
//  AFOLeadInPublicController.m
//  AFOLeadIn
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOLeadInPublicController.h"

@interface AFOLeadInPublicController ()
@property (nonatomic, strong) AFOLeadInNavigationController *navigationController;
@property (nonatomic, strong) AFOLeadInMainController       *mainController;
@end

@implementation AFOLeadInPublicController
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ 自定义
#pragma mark ------ 返回首页
- (UIViewController *)returnLeadInController{
    return self.navigationController;
}
#pragma mark ------------ 系统


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ 属性
#pragma mark ------ mainController
- (AFOLeadInMainController *)mainController{
    if (!_mainController) {
        _mainController = [[AFOLeadInMainController alloc]init];
    }
    return _mainController;
}
#pragma mark ------ navigationController
- (AFOLeadInNavigationController *)navigationController{
    if (!_navigationController) {
        _navigationController = [[AFOLeadInNavigationController alloc]initWithRootViewController:self.mainController];
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
