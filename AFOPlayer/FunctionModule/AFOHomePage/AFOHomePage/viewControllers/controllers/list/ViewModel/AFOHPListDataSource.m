//
//  AFOHPListDataSource.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListDataSource.h"
#import "AFOHPListCell.h"
#import "AFOHPListViewModel.h"
@interface AFOHPListDataSource ()
@property (nonatomic, assign) NSInteger              type;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@property (nonatomic, strong) AFOHPListViewModel    *viewModel;
@end

@implementation AFOHPListDataSource
#pragma mark ------ 数据源
- (void)settingDataArray:(NSArray *)array index:(NSInteger)index{
    self.type = index;
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
}
#pragma mark ------------ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    AFOHPListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AFOHPListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    ///---
    [self.viewModel settingAlbumObject:self.dataArray[indexPath.row] block:^(NSString *name) {
            cell.block(name, [AFOHPListViewModel artistsNameObject:self.dataArray[indexPath.row]], [AFOHPListViewModel albumImageWithSize:cell.imageSize object:self.dataArray[indexPath.row]], self.type);
    }];
    return cell;
}
#pragma mark ------------ property
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (AFOHPListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AFOHPListViewModel alloc] init];
    }
    return _viewModel;
}
@end
