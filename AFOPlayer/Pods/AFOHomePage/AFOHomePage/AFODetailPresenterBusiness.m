//
//  AFODetailPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFODetailPresenterBusiness.h"
#import <AFOFoundation/AFOFoundation.h>
#import <AFOGitHub/AFOGitHub.h>
#import "AFOHPDetailModel.h"
#import "AFOHPDetailDelegate.h"
#import "AFOHPDetailDataSource.h"
@interface AFODetailPresenterBusiness ()
@property (nonatomic, strong) AFOHPDetailDelegate    *delegate;
@property (nonatomic, strong) AFOHPDetailDataSource  *dataSource;
@property (nonatomic, strong) AFOHPDetailModel       *detailModel;
@property (nonatomic, strong, readwrite) NSMutableArray         *dataArray;
@property (nonatomic, strong, readwrite) NSNumber               *number;
@end

@implementation AFODetailPresenterBusiness
- (instancetype)init{
    if (self = [super init]) {
        [self hookMethodTarget:self.delegate selector:@selector(tableView:didSelectRowAtIndexPath:)];
    }
    return self;
}
#pragma mark ------ hook
- (void)hookMethodTarget:(id)target selector:(SEL)selector{
    WeakObject(self);
    [target aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        StrongObject(self);
        self.number = @(indexPath.item);
        [AFOHPDetailModel routerParams:self.dataArray indexPath:indexPath block:^(NSURL *url) {
            [[UIApplication sharedApplication] openURL:url];
        }];
    } error:NULL];
}
- (void)receiverRouterMessage:(id)model
                        block:(void(^)(NSString *title,
                                       NSInteger index,
                                       NSArray *array))block{
    NSDictionary *parameters = model;
    NSString *strTitle = [parameters objectForKey:@"value"];
    WeakObject(self);
    [self.detailModel detailDataForValue:strTitle type:parameters[@"type"]  block:^(NSArray *array) {
        StrongObject(self);
        [self.dataArray addObjectsFromArray:array];
        ///------
        [self.dataSource settingDataArray:array type:parameters[@"type"]];
        block(strTitle,[parameters[@"type"] integerValue],array);
    }];
}
#pragma mark ------ delegate
- (id)delegateTarget{
    return self.delegate;
}
#pragma mark ------ dataSource
- (id)dataSourceTarget{
    return self.dataSource;
}
#pragma mark ------ property
- (AFOHPDetailDelegate *)delegate{
    if (!_delegate) {
        _delegate = [[AFOHPDetailDelegate alloc] init];
    }
    return _delegate;
}
- (AFOHPDetailDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOHPDetailDataSource alloc] init];
    }
    return _dataSource;
}
- (AFOHPDetailModel *)detailModel{
    if (!_detailModel) {
        _detailModel = [[AFOHPDetailModel alloc] init];
    }
    return _detailModel;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end
