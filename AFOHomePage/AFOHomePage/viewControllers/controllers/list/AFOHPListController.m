//
//  AFOHPListController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListController.h"
#import "AFOHPListController+Router.h"
#import "AFOHPListDataSource.h"
#import "AFOHPListViewModel.h"
@interface AFOHPListController ()<AFORouterManagerDelegate,UITableViewDelegate>
@property (nonatomic, strong) UITableView             *tableView;
@property (nonatomic, strong) AFOHPListDataSource     *dataSource;
@property (nonatomic, strong, readwrite) AFOHPListViewModel      *viewModel;
@end

@implementation AFOHPListController

#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self tableViewdidSelectRowAtIndexPathExchange];
}
#pragma mark ------------ custom
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model{
    NSDictionary *parameters = model;
    self.title = [parameters objectForKey:@"value"];
    NSInteger index =[parameters[@"type"] integerValue];
    __weak typeof(self) weakSelf = self;
    [self.viewModel settingDataIndex:index block:^(NSArray *array) {
        [weakSelf.dataSource settingDataArray:array index:index];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark ------------ system
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
#pragma mark ------ mediaQuery
- (AFOHPListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AFOHPListViewModel alloc] init];
    }
    return _viewModel;
}
#pragma mark ------ dataSource
- (AFOHPListDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOHPListDataSource alloc] init];
    }
    return _dataSource;
}
#pragma mark ------------ property
#pragma mark ------ tableView
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource =self.dataSource;
    }
    return _tableView;
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
