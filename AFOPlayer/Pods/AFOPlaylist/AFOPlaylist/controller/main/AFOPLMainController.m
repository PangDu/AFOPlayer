//
//  AFOPlayListMainController.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOPLMainController.h"
#import <AFOFoundation/AFOFoundation.h>
#import <AFOGitHub/AFOGitHub.h>
#import "AFOPLMainControllerCategory.h"
#import "AFOPLMainCellDefaultLayout.h"
#import "AFOPLMainCollectionDataSource.h"
#import "AFOPLMainCollectionCell.h"
@interface AFOPLMainController ()<UICollectionViewDelegate>
@property (nonnull, nonatomic, strong) AFOPLMainCellDefaultLayout    *defaultLayout;
@property (nonnull, nonatomic, strong) AFOPLMainCollectionDataSource *collectionDataSource;
@property (nonnull, nonatomic, strong, readwrite) UICollectionView             *collectionView;
@end
@implementation AFOPLMainController
#pragma mark ------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.collectionView];
    [self collectionViewDidSelectRowAtIndexPathExchange];
    [self initializerInstance];
    [self addOperationButton];
}
#pragma mark ------ 设置初始值
- (void)initializerInstance{
    WeakObject(self);
    self.defaultLayout.block = ^CGFloat(CGFloat width, NSIndexPath *indexPath) {
        StrongObject(self);
        return [self vedioItemHeight:indexPath width:width];
    };
    ///------
    [self addCollectionViewData];
    ///------
    [self addPullToRefresh];
    ///---
    self.updateCollectionBlock = ^{
        StrongObject(self);
        [self addCollectionViewData];
    };
}
#pragma mark ------ 下拉刷新
- (void)addPullToRefresh{
    WeakObject(self);
    [self.collectionView addPullToRefreshWithActionHandler:^{
        StrongObject(self);
        [self addCollectionViewData];
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
}
#pragma mark ------ 获取数据
- (void)addCollectionViewData{
    WeakObject(self);
    [self addCollectionViewData:^(NSArray *array) {
        StrongObject(self);
        [self.collectionDataSource settingImageData:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView performWithoutAnimation:^{
                [self.collectionView reloadData];
            }];
        });
    }];
}
#pragma mark ------ UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark ------------ property
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) collectionViewLayout:self.defaultLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self.collectionDataSource;
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:[AFOPLMainCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([AFOPLMainCollectionCell class])];
    }
    return _collectionView;
}
- (AFOPLMainCollectionDataSource *)collectionDataSource{
    if (!_collectionDataSource) {
        _collectionDataSource = [[AFOPLMainCollectionDataSource alloc] init];
    }
    return _collectionDataSource;
}
- (AFOPLMainCellDefaultLayout *)defaultLayout{
    if (!_defaultLayout) {
        _defaultLayout = [[AFOPLMainCellDefaultLayout alloc] init];
    }
    return _defaultLayout;
}
#pragma mark ------ 是否可以旋转
- (BOOL)shouldAutorotate{
    return YES;
}
#pragma mark ------ 支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPLMainController dealloc");
}
@end
