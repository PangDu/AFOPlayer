//
//  AFOHPListDataSource.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListDataSource.h"
#import "AFOHPListCell.h"
@interface AFOHPListDataSource ()
@property (nonatomic, assign) NSInteger       type;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AFOHPListDataSource
#pragma mark ------------ custom
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
    [cell settingSubviewsValue:self.dataArray[indexPath.row] type:self.type];
    return cell;
}
#pragma mark ------------ property
#pragma mark ------ dataArray
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
