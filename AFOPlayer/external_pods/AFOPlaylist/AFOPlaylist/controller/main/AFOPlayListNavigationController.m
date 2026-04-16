//
//  AFOPlayListNavigationController.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOPlayListNavigationController.h"
#import <UIKit/UIKit.h>

@interface AFOPlayListNavigationController () <UINavigationControllerDelegate>
@end

@implementation AFOPlayListNavigationController
#pragma mark ------------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"播放列表";
    self.delegate = self;

    // 栈级别兜底：有些全局主题/二进制 Pod 可能通过 UIAppearance 覆盖标题样式，
    // 导致标题“存在但不可见”。在播放列表导航栈内强制恢复为可见样式。
    self.navigationBar.hidden = NO;
    self.navigationBar.alpha = 1.0;
    self.navigationBar.translucent = NO;
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = NO;
    }
    UIColor *titleColor = [UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.titleTextAttributes = @{ NSForegroundColorAttributeName : titleColor };
        appearance.largeTitleTextAttributes = @{ NSForegroundColorAttributeName : titleColor };
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationBar.compactAppearance = appearance;
    } else {
        self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : titleColor };
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    if (!viewController) {
        return;
    }
    if (@available(iOS 11.0, *)) {
        viewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    }
    // 如果外部没设置标题，兜底使用 vc.title（或已存在的 navigationItem.title）
    NSString *t = viewController.navigationItem.title.length > 0 ? viewController.navigationItem.title : viewController.title;
    if (t.length > 0) {
        viewController.navigationItem.title = t;
    }
}
#pragma mark ------
-(BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}
#pragma mark ------ 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
