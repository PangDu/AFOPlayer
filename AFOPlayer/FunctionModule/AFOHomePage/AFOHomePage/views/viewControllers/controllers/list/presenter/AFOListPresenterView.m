//
//  AFOListPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOListPresenterView.h"

@interface AFOListPresenterView ()
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, weak) id<AFOHPPresenterDelegate>delegate;
@end

@implementation AFOListPresenterView
- (instancetype)initWithDelegate:(id<AFOHPPresenterDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
        [self bindingTableView];
    }
    return self;
}
#pragma mark ------ bindingView
- (void)bindingTableView{
    [self.delegate bindingView:self.tableView];
}
#pragma mark ------ reloadData
- (void)loadDataAction{
    [self.tableView reloadData];
}
#pragma mark ------ property
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    }
    return _tableView;
}
@end
