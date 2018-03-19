//
//  AFOLeadInMainController.m
//  AFOLeadIn
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOLeadInMainController.h"

@interface AFOLeadInMainController ()

@end

@implementation AFOLeadInMainController

#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = AFOLEADINTITLESTRING;
    // Do any additional setup after loading the view.
}
#pragma mark ------------ 自定义
#pragma mark ------------ 系统
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
