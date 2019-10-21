//
//  AFOTabBarController.m
//  AFOUIKit
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOTabBarController.h"

@interface AFOTabBarController ()<UITabBarControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)   UIScrollView                             *scrollView;
@property (nonatomic, strong)   NSArray<__kindof UIViewController *>     *controllerArray;
@property (nonatomic, assign)   NSInteger                                 userSelectIndex;
@end
@implementation AFOTabBarController
#pragma mark ------ view load
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    _controllerArray = [[NSMutableArray alloc] init];
    [self.view insertSubview:self.scrollView belowSubview:self.tabBar];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark ------ override
- (NSArray *)viewControllers{
    return nil;
}
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers{
    [self setViewControllers:viewControllers animated:NO];
}
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
                  animated:(BOOL)animated{
    self.controllerArray = viewControllers;
}
- (UIViewController *)selectedViewController{
    return self.controllerArray[self.userSelectIndex];
}
- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController{
    self.userSelectIndex = [self.controllerArray indexOfObject:selectedViewController];
}
- (NSUInteger)selectedIndex{
    return self.userSelectIndex;
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    self.userSelectIndex = selectedIndex;
    CGRect rectVisible = CGRectMake(CGRectGetWidth(self.view.frame) * selectedIndex, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    [self.scrollView scrollRectToVisible:rectVisible animated:NO];
}
- (void)setControllerArray:(NSArray<__kindof UIViewController *> *)controllerArray{
    _controllerArray = controllerArray;
    [controllerArray enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        obj.view.frame = CGRectMake(CGRectGetWidth(self.view.frame) * idx, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [self.scrollView addSubview:obj.view];
    }];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * controllerArray.count, CGRectGetHeight(self.view.frame));
}
#pragma mark ------ UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
    self.userSelectIndex = index;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.userSelectIndex = scrollView.contentOffset.x / CGRectGetWidth(self.view.frame);
}
#pragma mark ------ UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.selectedViewController = viewController;
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController{
    self.selectedViewController = viewController;
}
- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController {
    return tabBarController.selectedViewController.supportedInterfaceOrientations;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ property
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
