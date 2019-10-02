//
//  AFOPlayListPublicController.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOPlayListForeign.h"
#import "AFOPlayListNavigationController.h"
#import "AFOPLMainController.h"

@interface AFOPlayListForeign ()
@property (nonnull, nonatomic, strong) AFOPlayListNavigationController *navigationController;
@property (nonnull, nonatomic, strong) AFOPLMainController       *mainController;
@end
@implementation AFOPlayListForeign
#pragma mark ------ add controller
- (UIViewController *)returnController{
    return self.navigationController;
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------ property
- (AFOPLMainController *)mainController{
    if (!_mainController) {
        _mainController = [[AFOPLMainController alloc]init];
    }
    return _mainController;
}
- (AFOPlayListNavigationController *)navigationController{
    if (!_navigationController) {
        _navigationController = [[AFOPlayListNavigationController alloc]initWithRootViewController:self.mainController];
    }
    return _navigationController;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPlayListForeign dealloc");
}
@end
