//
//  AFOHPMainController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPMainController.h"
@interface AFOHPMainController ()
@property (nonatomic, strong) AFOCardStackingController *cardStacking;

@end

@implementation AFOHPMainController
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = AFOHPTITLESTRING;
    [self loadCustomView];
}
#pragma mark ------------ loadCustomView
- (void)loadCustomView{
    [self addChildViewController:self.cardStacking];
    [self.view addSubview:self.cardStacking.view];
}
//- (id)didSenderControllerRouterManagerDelegate{
//    return @"mainController";
//}
#pragma mark ------------ system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
- (AFOCardStackingController *)cardStacking{
    if (!_cardStacking) {
        _cardStacking = [[AFOCardStackingController alloc]init];
    }
    return _cardStacking;
}

@end
