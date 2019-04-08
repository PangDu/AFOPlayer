//
//  AFOHPDetailController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/19.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPDetailController.h"
#import "AFOHPDetailController+Router.h"
#import "AFOHPDetailDataSource.h"
#import "AFOHPDetailViewModel.h"
@interface AFOHPDetailController ()<UITableViewDelegate,AFORouterManagerDelegate>
@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, strong) AFOHPDetailDataSource   *dataSource;
@property (nonatomic, strong) AFOHPDetailViewModel    *viewModel;
@end

@implementation AFOHPDetailController

#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    ///------
    [self tableViewdidSelectRowAtIndexPathExchange];
    ///------
    [self detailAddSubviews];
    // Do any additional setup after loading the view.
}
#pragma mark ------ detailAddSubviews
- (void)detailAddSubviews{
    [self.view addSubview:self.tableView];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model{
    NSDictionary *parameters = model;
    self.title = parameters[@"value"];
    __weak typeof(self) weakSelf = self;
    [self.viewModel detailDataForValue:self.title type:parameters[@"type"]  block:^(NSArray *array) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        ///------
        strongSelf.hpDetailArray = [NSMutableArray arrayWithArray:array];
        ///------
        if (strongSelf) {
            [strongSelf.dataSource settingDataArray:array type:parameters[@"type"]];
            [strongSelf.tableView reloadData];
        }
    }];
}
#pragma mark ------ 传值
- (id)didSenderRouterManagerDelegate{
    NSDictionary *dictonary = @{
                                @"index" : self.selectNumber,
                                @"data"  : self.hpDetailArray
                                };
    return dictonary;//self.hpDetailArray[[self.selectNumber integerValue]];
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
#pragma mark ------------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
- (AFOHPDetailDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOHPDetailDataSource alloc] init];
    }
    return _dataSource;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self.dataSource;
    }
    return _tableView;
}
- (AFOHPDetailViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AFOHPDetailViewModel alloc] init];
    }
    return _viewModel;
}
@end
