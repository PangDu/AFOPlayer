//
//  AFOCardStackingController.m
//  AFOAnimationHighlights
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOCardStackingController.h"
#import "AFOCardStackingController+Router.h"
#import "AFOCardStackCollectionDataSource.h"
#import "CardStackingViewModel.h"
#import "AFOCardStackCollectionCell.h"
#import "AFOCardStackDefaultLayout.h"
#import "AFOCardStackSelectedLayout.h"
@interface AFOCardStackingController ()<UICollectionViewDelegate>
@property (nullable, nonatomic, strong) UICollectionView          *collectionView;
@property (nullable, nonatomic, strong) UICollectionViewLayout *cardLayout;
@property (nullable, nonatomic, strong) AFOCardStackDefaultLayout *defaultLayout;
@property (nullable, nonatomic, strong) AFOCardStackSelectedLayout *selectedLayout;
@property (nullable, nonatomic, strong) AFOCardStackCollectionDataSource *cardStackDataSource;
@end

@implementation AFOCardStackingController

#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self tableViewdidSelectRowAtIndexPathExchange];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ custom
#pragma mark ------------ API
#pragma mark ------ UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ 属性
#pragma mark ------ cardStackDataSource
- (nullable AFOCardStackCollectionDataSource *)cardStackDataSource{
    if (!_cardStackDataSource) {
        _cardStackDataSource = [[AFOCardStackCollectionDataSource alloc]init];
        _cardStackDataSource.cellCount = 4;
    }
    return _cardStackDataSource;
}
#pragma mark ------ defaultLayout
- (AFOCardStackDefaultLayout *)defaultLayout{
    if (!_defaultLayout) {
        _defaultLayout = [[AFOCardStackDefaultLayout alloc]init];
    }
    return _defaultLayout;
}
#pragma mark ------ selectedLayout
- (AFOCardStackSelectedLayout *)selectedLayout{
    if (!_selectedLayout) {
        _selectedLayout = [[AFOCardStackSelectedLayout alloc]init];
    }
    return _selectedLayout;
}
#pragma mark ------ cardLayout
- (UICollectionViewLayout *)cardLayout{
    if (!_cardLayout) {
        _cardLayout = [[UICollectionViewLayout alloc]init];
    }
    return _cardLayout;
}
#pragma mark ------ collectionView
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.defaultLayout];
        _collectionView.backgroundColor = RGBColorC(0x2D3142);
        _collectionView.delegate = self;
        _collectionView.dataSource = self.cardStackDataSource;
        [_collectionView setContentOffset:CGPointMake(0, 64*3)];
        [_collectionView registerClass:[AFOCardStackCollectionCell class] forCellWithReuseIdentifier:@"cardStackCell"];
    }
    return _collectionView;
}
#pragma mark ------ viewModel
- (CardStackingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CardStackingViewModel alloc]init];
    }
    return _viewModel;
}
@end
