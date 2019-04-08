//
//  AFOListPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOListPresenterBusiness.h"
#import "AFOHPListModel.h"
@interface AFOListPresenterBusiness ()
@property (nonatomic, strong) AFOHPListModel *listModel;
@end

@implementation AFOListPresenterBusiness
#pragma mark ------ hook
- (void)hookMethodTarget:(id)target selector:(SEL)selector{
    [target aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
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
        block(strTitle,index,array);
    }];
}
#pragma mark ------ property
- (AFOHPListModel *)listModel{
    if (!_listModel) {
        _listModel = [[AFOHPListModel alloc] init];
    }
    return _listModel;
}
@end
