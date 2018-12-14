//
//  AFOPLMainController+Operation.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController+Operation.h"
#import "AFOPLMainManager.h"

@interface AFOPLMainController ()<UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isShow;
@end
@implementation AFOPLMainController (Operation)
#pragma mark ------
- (void)setIsShow:(BOOL)isShow{
    objc_setAssociatedObject(self, @selector(setIsShow:), @(isShow), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isShow{
    NSNumber *numVaue = objc_getAssociatedObject(self, @selector(setIsShow:));
    return [numVaue integerValue];
}
#pragma mark ------
- (void)addOperationButton{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleateVedioOperation:)];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)addLeftItem{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllVedioItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)deleateVedioOperation:(id)sender{
    if (!self.isData) {
        return;
    }
    if (!self.isShow) {
        [self addLeftItem];
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
    }else{
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.isShow = !self.isShow;
}
- (void)selectAllVedioItem{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除全部影片！" message:@"请再次确认是否全部删除！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = 100;
    [alertView show];
}
#pragma mark ------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        [AFOPLMainManager deleteMovieRelatedContentLocally:self.isShow block:^(BOOL isSucess) {
            if (isSucess) {
                [self addCollectionViewData];
            }
            [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
            self.navigationItem.leftBarButtonItem = nil;
        }];
    }
}
@end
