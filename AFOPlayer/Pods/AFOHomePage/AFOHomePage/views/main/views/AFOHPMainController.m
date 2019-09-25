//
//  AFOHPMainController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPMainController.h"
#import "AFOMainPresenterView.h"
@interface AFOHPMainController ()<AFOHPPresenterDelegate>
@property (nonatomic, strong) AFOMainPresenterView *presenterView;
@end

@implementation AFOHPMainController
#pragma mark ------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self.presenterView bindingCardStacking];
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ AFOHPPresenterDelegate
- (void)bindingController:(UIViewController *)controller{
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
}
#pragma mark ------ property
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFOMainPresenterView alloc] initWithDelegate:self];
    }
    return _presenterView;
}
@end
