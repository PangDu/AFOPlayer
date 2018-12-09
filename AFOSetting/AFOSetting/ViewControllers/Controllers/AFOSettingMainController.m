//
//  AFOSettingMainController.m
//  AFOSetting
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOSettingMainController.h"
@interface AFOSettingMainController ()
@end
@implementation AFOSettingMainController

#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadMianView];
    // Do any additional setup after loading the view.
}
#pragma mark ------ title
- (void)loadMianView{
    self.title = AFOSETTINGTITLESTRING;
    self.tabBarItem.title = AFOSETTINGTITLESTRING;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
