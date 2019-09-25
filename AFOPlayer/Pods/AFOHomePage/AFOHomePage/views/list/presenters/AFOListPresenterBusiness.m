//
//  AFOListPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOListPresenterBusiness.h"
#import <AFOGitHub/AFOGitHub.h>
#import "AFOHPListModel.h"
#import "AFOHPListDelegate.h"
#import "AFOHPListDataSource.h"
@interface AFOListPresenterBusiness ()
@property (nonatomic, strong) AFOHPListModel       *listModel;
@property (nonatomic, strong) AFOHPListDelegate    *delegate;
@property (nonatomic, strong) AFOHPListDataSource  *dataSource;
@end

@implementation AFOListPresenterBusiness
- (instancetype)init{
    if (self = [super init]) {
        [self hookMethodTarget:self.delegate selector:@selector(tableView:didSelectRowAtIndexPath:)];
    }
    return self;
}
#pragma mark ------ hook
- (void)hookMethodTarget:(id)target selector:(SEL)selector{
    [target aspect_hookSelector:selector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
            NSURL *url = [self.listModel settingRouterUrl:indexPath];
            if (url != nil) {
                [[UIApplication sharedApplication] openURL:url];
            }
    } error:NULL];
}
#pragma mark ------
- (void)receiverRouterMessage:(id)model block:(void(^)(NSString *title,
                                                       NSInteger index,
                                                       NSArray *array))block{
    NSDictionary *parameters = model;
    NSString *strTitle = [parameters objectForKey:@"value"];
    NSInteger index = [parameters[@"type"] integerValue];
    [self.listModel settingDataIndex:index block:^(NSArray *array) {
        [self.dataSource settingDataArray:array index:index];
        block(strTitle,index,array);
    }];
}
#pragma mark ------ UITableViewDelegate
- (id)delegateTarget{
    return self.delegate;
}
#pragma mark ------ UITableViewDataSource
- (id)dataSourceTarget{
    return self.dataSource;
}
#pragma mark ------ property
- (AFOHPListModel *)listModel{
    if (!_listModel) {
        _listModel = [[AFOHPListModel alloc] init];
    }
    return _listModel;
}
- (AFOHPListDelegate *)delegate{
    if (!_delegate) {
        _delegate = [[AFOHPListDelegate alloc] init];
    }
    return _delegate;
}
- (AFOHPListDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOHPListDataSource alloc] init];
    }
    return _dataSource;
}
@end
