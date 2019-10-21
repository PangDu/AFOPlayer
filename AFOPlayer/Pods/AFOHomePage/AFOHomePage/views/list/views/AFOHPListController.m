//
//  AFOHPListController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListController.h"
#import <AFORouter/AFORouter.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFOSchedulerCore/AFOSchedulerPassValueDelegate.h>
#import "AFOListPresenterView.h"
#import "AFOListPresenterBusiness.h"
@interface AFOHPListController ()<AFOSchedulerPassValueDelegate,AFOHPPresenterDelegate>
@property (nonatomic, strong) AFOListPresenterView           *presenterView;
@property (nonatomic, strong) AFOListPresenterBusiness       *presenterBusiness;
@end

@implementation AFOHPListController
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenterView bindingTableView];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)schedulerReceiverRouterManagerDelegate:(id)model{
    WeakObject(self);
    [self.presenterBusiness receiverRouterMessage:model block:^(NSString * _Nonnull title, NSInteger index,NSArray *_Nonnull array) {
        StrongObject(self);
        self.title = title;
        [self.presenterView loadDataAction];
    }];
}
#pragma mark ------ AFOHPPresenterDelegate
- (void)bindingView:(UIView *)view{
    UITableView *tableView = (UITableView *)view;
    tableView.delegate = [self.presenterBusiness delegateTarget];
    tableView.dataSource =[self.presenterBusiness dataSourceTarget];
    [self.view addSubview:tableView];
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
- (AFOHPPresenter *)presenterBusiness{
    if (!_presenterBusiness) {
        _presenterBusiness = [[AFOListPresenterBusiness alloc] init];
    }
    return _presenterBusiness;
}
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFOListPresenterView alloc] initWithDelegate:self];
    }
    return _presenterView;
}
@end
