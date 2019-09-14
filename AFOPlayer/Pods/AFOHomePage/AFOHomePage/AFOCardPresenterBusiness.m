//
//  AFOCardPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOCardPresenterBusiness.h"
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
        ///------
        NSString *baseStr = [[AFORouterManager shareInstance] settingPushControllerRouter:strController present:@"AFOCardStackingController" params:[self.stackingModel dictionaryIndex:indexPath.row]];
        NSURL *url = [NSURL URLWithString:baseStr];
        [[UIApplication sharedApplication] openURL:url];
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
