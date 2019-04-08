//
//  AFOHPListController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListController.h"
#import "AFOHPListDataSource.h"
#import "AFOListPresenterView.h"
#import "AFOListPresenterBusiness.h"
@interface AFOHPListController ()<AFORouterManagerDelegate,UITableViewDelegate>
@property (nonatomic, strong) UITableView                    *tableView;
@property (nonatomic, strong) AFOHPListDataSource            *dataSource;
@property (nonatomic, strong) AFOListPresenterBusiness       *listModel;
@end

@implementation AFOHPListController
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.listModel hookMethodTarget:self selector:@selector(tableView:didSelectRowAtIndexPath:)];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model{
    WeakObject(self);
    [self.listModel receiverRouterMessage:model block:^(NSString * _Nonnull title, NSInteger index,NSArray *_Nonnull array) {
        StrongObject(self);
        self.title = title;
        [self.dataSource settingDataArray:array index:index];
        [self.tableView reloadData];
    }];
}
#pragma mark ------ UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 10)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
- (AFOListPresenterBusiness *)listModel{
    if (!_listModel) {
        _listModel = [[AFOListPresenterBusiness alloc] init];
    }
    return _listModel;
}
- (AFOHPListDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOHPListDataSource alloc] init];
    }
    return _dataSource;
}
#pragma mark ------------ property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self.dataSource;
    }
    return _tableView;
}
@end
