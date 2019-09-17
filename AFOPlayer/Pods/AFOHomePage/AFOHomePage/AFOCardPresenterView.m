//
//  AFOCardPresenterView.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOCardPresenterView.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOCardStackDefaultLayout.h"
#import "AFOCardStackCollectionCell.h"
@interface AFOCardPresenterView ()
@property (nonatomic, strong) AFOCardStackDefaultLayout *defaultLayout;
@property (nonatomic, strong) UICollectionView          *collectionView;
@property (nonatomic, strong) UIImageView               *backImageView;
@property (nonatomic, weak) id<AFOHPPresenterDelegate>   delegate;
@end

@implementation AFOCardPresenterView
#pragma mark ------ initWithDelegate
- (instancetype)initWithDelegate:(id<AFOHPPresenterDelegate>)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}
#pragma mark ------ bindingCollectionView
- (void)bindingCollectionView{
    self.collectionView.backgroundView = self.backImageView;
    [self.delegate bindingView:self.collectionView];
}
#pragma mark ------ property
- (AFOCardStackDefaultLayout *)defaultLayout{
    if (!_defaultLayout) {
        _defaultLayout = [[AFOCardStackDefaultLayout alloc]init];
    }
    return _defaultLayout;
}
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSBundle imageNameFromBundle:@"AFOHomePage.bundle" source:@"hp_homePageBack.jpg"]]];
        [_backImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        _backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:self.defaultLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView setContentOffset:CGPointMake(0, 64*3)];
        [_collectionView registerClass:[AFOCardStackCollectionCell class] forCellWithReuseIdentifier:@"cardStackCell"];
    }
    return _collectionView;
}
@end
