//
//  AFOPLMainController+Operation.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController+Operation.h"
#import "AFOPLMainManager.h"
@implementation AFOPLMainController (Operation)
- (void)addOperationButton{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleateVedioOperation:)];
    self.navigationItem.rightBarButtonItem = backItem;
}
- (void)deleateVedioOperation:(id)sender{
    [AFOPLMainManager deleteMovieRelatedContentLocally];
}
@end
