//
//  AFOHPDetailController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/19.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPDetailController.h"
#import <AFORouter/AFORouter.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFOSchedulerCore/AFOSchedulerPassValueDelegate.h>
#import "AFODetailPresenterView.h"
#import "AFODetailPresenterBusiness.h"
@interface AFOHPDetailController ()<AFOSchedulerPassValueDelegate,AFOHPPresenterDelegate>
@property (nonatomic, strong) AFODetailPresenterView  *presenterView;
@property (nonatomic, strong) AFODetailPresenterBusiness *business;
@end
@implementation AFOHPDetailController
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenterView bindingTableView];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)schedulerReceiverRouterManagerDelegate:(id)model{
    WeakObject(self);
    [self.business receiverRouterMessage:model block:^(NSString * _Nonnull title, NSInteger index, NSArray * _Nonnull array) {
        StrongObject(self);
        self.title = title;
        [self.presenterView loadDataAction];
    }];
}
#pragma mark ------ AFOHPPresenterDelegate
- (void)bindingView:(UIView *)view{
    UITableView *tableView = (UITableView *)view;
    tableView.delegate = [self.business delegateTarget];
    tableView.dataSource =[self.business dataSourceTarget];
    [self.view addSubview:tableView];
}
#pragma mark ------ 传值
- (id)schedulerSenderRouterManagerDelegate{
    NSDictionary *dictonary = @{
                                @"index" : self.business.number,
                                @"data"  : self.business.dataArray
                                };
    return dictonary;
}
#pragma mark ------------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark ------------ property
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFODetailPresenterView alloc] initWithDelegate:self];
    }
    return _presenterView;
}
- (AFOHPPresenter *)business{
    if (!_business) {
        _business = [[AFODetailPresenterBusiness alloc] init];
    }
    return _business;
}
@end
