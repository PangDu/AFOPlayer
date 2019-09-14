//
//  AFOCardStackingController.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOCardStackingController.h"
#import "AFOCardPresenterBusiness.h"
#import "AFOCardPresenterView.h"
@interface AFOCardStackingController ()<AFOHPPresenterDelegate>
@property (nonatomic, strong) AFOCardPresenterView     *presenterView;
@property (nonatomic, strong) AFOCardPresenterBusiness *presenterBusiness;
@end

@implementation AFOCardStackingController
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenterView bindingCollectionView];
}
#pragma mark ------ AFOHPPresenterDelegate
- (void)bindingView:(UIView *)view{
    UICollectionView *collectionView = (UICollectionView *)view;
    collectionView.delegate = [self.presenterBusiness delegateTarget];
    collectionView.dataSource = [self.presenterBusiness dataSourceTarget];
    [self.view addSubview:collectionView];
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark ------------ property
- (AFOHPPresenter *)presenterBusiness{
    if (!_presenterBusiness) {
        _presenterBusiness = [[AFOCardPresenterBusiness alloc] init];
    }
    return _presenterBusiness;
}
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFOCardPresenterView alloc] initWithDelegate:self];
    }
    return _presenterView;
}
@end
