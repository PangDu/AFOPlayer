//
//  AFOPlayListPublicController.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOPlayListForeign.h"
#import "AFOPlayListNavigationController.h"
#import "AFOPLMainController.h"

@interface AFOPlayListForeign ()
@property (nonatomic, strong) AFOPlayListNavigationController *navigationController;
@property (nonatomic, strong) AFOPLMainController       *mainController;

@end

@implementation AFOPlayListForeign
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ custom
#pragma mark ------ add controller
- (UIViewController *)returnPlayListController{
    return self.navigationController;
}
#pragma mark ------------ system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
#pragma mark ------ mainController
- (AFOPLMainController *)mainController{
    if (!_mainController) {
        _mainController = [[AFOPLMainController alloc]init];
    }
    return _mainController;
}
#pragma mark ------ navigationController
- (AFOPlayListNavigationController *)navigationController{
    if (!_navigationController) {
        _navigationController = [[AFOPlayListNavigationController alloc]initWithRootViewController:self.mainController];
    }
    return _navigationController;
}
@end
