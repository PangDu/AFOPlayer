//
//  AFOCardPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOCardPresenterBusiness.h"
#import <AFOGitHub/AFOGitHub.h>
#import <AFORouter/AFORouter.h>
#import <AFOFoundation/AFOFoundation.h>
#import "AFOCardStackingModel.h"
#import "AFOCardStackCollectionDelegate.h"
#import "AFOCardStackCollectionDataSource.h"

@interface AFOCardPresenterBusiness ()
@property (nonatomic, strong) AFOCardStackCollectionDelegate *delegate;
@property (nonatomic, strong) AFOCardStackCollectionDataSource *dataSource;
@property (nonatomic, strong) AFOCardStackingModel   *stackingModel;
@end

@implementation AFOCardPresenterBusiness
- (instancetype)init{
    if (self = [super init]) {
        [self hookMethodTarget:self.delegate selector:@selector(tableView:didSelectRowAtIndexPath:)];
    }
    return self;
}
#pragma mark ------ hookMethodTarget
- (void)hookMethodTarget:(id)target selector:(SEL)selector{
    [target aspect_hookSelector:@selector(collectionView:didSelectItemAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        NSString *strController = @"AFOHPListController";
        if (indexPath.row == 3) {
            strController = @"AFOHPDetailController";
        }
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[self.stackingModel dictionaryIndex:indexPath.row]];
        [dic setObject:@"homePage" forKey:@"modelName"];
        [dic setObject:@"AFOHPMainController" forKey:@"current"];
        [dic setObject:strController forKey:@"next"];
        [dic setObject:@"push" forKey:@"action"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString settingRoutesParameters:dic]]];
    } error:NULL];
}
#pragma mark ------ UICollectionViewDelegate
- (id)delegateTarget{
    return self.delegate;
}
#pragma mark ------ UICollectionViewDataSource
- (id)dataSourceTarget{
    return self.dataSource;
}
#pragma mark ------ property
- (AFOCardStackCollectionDelegate *)delegate{
    if (!_delegate) {
        _delegate = [[AFOCardStackCollectionDelegate alloc] init];
    }
    return _delegate;
}
- (AFOCardStackCollectionDataSource *)dataSource{
    if (!_dataSource) {
        _dataSource = [[AFOCardStackCollectionDataSource alloc] init];
        _dataSource.cellCount = 4;
    }
    return _dataSource;
}
- (AFOCardStackingModel *)stackingModel{
    if (!_stackingModel) {
        _stackingModel = [[AFOCardStackingModel alloc] init];
    }
    return _stackingModel;
}
@end
