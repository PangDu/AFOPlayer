//
//  AFOHPDetailDataSource.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPDetailDataSource.h"
#import "AFOHPDetailModel.h"
#import "AFOHPDetailCell.h"

@interface AFOHPDetailDataSource ()
@property (nonatomic, assign) NSInteger              type;
@property (nonatomic, strong) NSMutableArray        *dataArray;
@end
@implementation AFOHPDetailDataSource
#pragma mark ------ settingDataArray
- (void)settingDataArray:(NSArray *)array type:(id)type{
    self.type = [type integerValue];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
}
#pragma mark ------------ system
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    AFOHPDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AFOHPDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }
    [AFOHPDetailModel songsDetails:self.dataArray[indexPath.row] block:^(NSDictionary *dictionary) {
        cell.block(dictionary[@"albumTitle"], dictionary[@"title"], [AFOHPDetailModel albumImageWithSize:cell.imageSize object:self.dataArray[indexPath.row]], self.type);
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
@end
