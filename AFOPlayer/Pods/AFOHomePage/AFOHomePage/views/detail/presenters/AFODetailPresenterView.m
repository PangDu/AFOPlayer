//
//  AFODetailPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFODetailPresenterView.h"

@interface AFODetailPresenterView ()
@property (nonatomic, strong) UITableView            *tableView;
@end

@implementation AFODetailPresenterView
#pragma mark ------ bindingView
- (void)bindingTableView{
    [self.presenterDelegate bindingView:self.tableView];
}
#pragma mark ------ reloadData
- (void)loadDataAction{
    [self.tableView reloadData];
}
#pragma mark ------ property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    }
    return _tableView;
}
@end
