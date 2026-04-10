//
//  AFOPLMainController.m
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
#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#if DEBUG
    NSLog(@"AFOPLMainController: viewWillAppear called. Hiding TabBar.");
#endif
    self.tabBarController.tabBar.hidden = YES;

    if (self.navigationController) {
#if DEBUG
        NSLog(@"AFOPLMainController: navigationController exists.");
#endif
        // 确保导航栏是可见的，如果其父控制器或相关配置导致隐藏，此处可强制显示
        self.navigationController.navigationBar.hidden = NO;
        self.navigationController.navigationBar.alpha = 1.0;
        self.navigationController.navigationBar.translucent = NO;
        // 标题设置应保持在 viewDidLoad 或初始化时
        // self.navigationItem.title = @"播放列表";
        // 移除诊断性背景色设置
        // self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    } else {
#if DEBUG
        NSLog(@"AFOPLMainController: navigationController is NIL. This might be the problem.");
#endif
    }
}

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // self.view.backgroundColor = [UIColor redColor]; // 移除诊断用的背景色
    self.title = @"播放列表";
    // self.automaticallyAdjustsScrollViewInsets = NO; // 移除或注释掉此行，让系统自动调整布局
    [self.view addSubview:self.collectionView];
    [self collectionViewDidSelectRowAtIndexPathExchange];
}
#pragma mark - Layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.isInitialized) {
        [self initializerInstance];
        [self.editorLogic setupEditButton];
        self.isInitialized = YES;
        // 初次布局时强制刷新，避免视图问题
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView layoutIfNeeded];
    }
}
#pragma mark - Private Methods

- (void)setupLayoutBlock {
    __weak typeof(self) weakSelf = self;
    self.defaultLayout.block = ^CGFloat(CGFloat width, NSIndexPath *indexPath) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        return [self vedioItemHeight:indexPath width:width];
    };
}

- (void)configureCollectionViewData {
    [self addCollectionViewData];
}

- (void)initializerInstance {
    [self setupLayoutBlock];
    [self configureCollectionViewData];
    [self addPullToRefresh]; 
    __weak typeof(self) weakSelf = self;
    self.editorLogic.updateCollectionBlock = ^{ // Block 应该在合适的时机被触发，这里只是初始化
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [self configureCollectionViewData];
    };
}
#pragma mark ------ 下拉刷新
- (void)addPullToRefresh{
     __weak typeof(self) weakSelf = self;
     [self.collectionView addPullToRefreshWithActionHandler:^{
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [self.collectionView.pullToRefreshView stopAnimating];
     }];
}
#pragma mark - Data Handling

- (void)addCollectionViewData {
    __weak typeof(self) weakSelf = self;
    [self addCollectionViewData:^(NSArray *array) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [self.collectionDataSource settingImageData:array];
        // 确保在主线程更新 UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
#if DEBUG
    NSLog(@"AFOPLMainController: Original collectionView:didSelectItemAtIndexPath: called. Index Path: %@", indexPath);
#endif
}
#pragma mark - Accessors
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.defaultLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self.collectionDataSource;
        _collectionView.alwaysBounceVertical=YES;
        [_collectionView registerClass:[AFOPLMainCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([AFOPLMainCollectionCell class])];
        NSLog(@"AFOPLMainController: CollectionView created. Delegate: %p, DataSource: %p, UserInteractionEnabled: %d, Frame: %@", _collectionView.delegate, _collectionView.dataSource, _collectionView.userInteractionEnabled, NSStringFromCGRect(_collectionView.frame));
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
#pragma mark - Orientation
- (BOOL)shouldAutorotate{
    return YES;
}
#pragma mark ------ 支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - Memory Management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Deallocation
- (void)dealloc{
#if DEBUG
    NSLog(@"AFOPLMainController dealloc");
#endif
}


#pragma mark ------ viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if DEBUG
    NSLog(@"AFOPLMainController: viewDidAppear called.");
#endif
    if (self.navigationController) {
#if DEBUG
        NSLog(@"AFOPLMainController: viewDidAppear - navigationController exists.");
#endif
#if DEBUG
        NSLog(@"AFOPLMainController: viewDidAppear - navigationBar hidden: %d", self.navigationController.navigationBar.hidden);
        NSLog(@"AFOPLMainController: viewDidAppear - navigationBar alpha: %f", self.navigationController.navigationBar.alpha);
        NSLog(@"AFOPLMainController: viewDidAppear - navigationBar frame: %@", NSStringFromCGRect(self.navigationController.navigationBar.frame));
#endif
        self.navigationController.navigationBar.hidden = NO; // 确保导航栏没有被隐藏
        self.navigationController.navigationBar.alpha = 1.0; // 确保导航栏完全可见
    } else {
#if DEBUG
        NSLog(@"AFOPLMainController: viewDidAppear - navigationController is NIL.");
#endif
    }
}

#pragma mark ------ viewDidDisappear
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
#if DEBUG
    NSLog(@"AFOPLMainController: viewDidDisappear called. Showing TabBar.");
#endif
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - AFOTabRootControllerProviding
- (UIViewController *)returnController {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self];
#if DEBUG
    NSLog(@"AFOPLMainController: returnController called. Returning UINavigationController: %p with root: %p", navController, self);
#endif
    return navController;
}

@end
