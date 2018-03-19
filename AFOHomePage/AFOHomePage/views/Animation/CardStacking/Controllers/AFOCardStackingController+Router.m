//
//  AFOCardStackingController+Router.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/27.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOCardStackingController+Router.h"
#import "CardStackingViewModel.h"
@implementation AFOCardStackingController (Router)
- (void)tableViewdidSelectRowAtIndexPathExchange{
    [self aspect_hookSelector:@selector(collectionView:didSelectItemAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        NSString *strController = @"AFOHPListController";
        if (indexPath.row == 3) {
            strController = @"AFOHPDetailController";
        }
        ///------
        NSString *baseStr = [[AFORouterManager shareInstance] settingPushControllerRouter:strController present:NSStringFromClass([self class]) params:[self.viewModel dictionaryIndex:indexPath.row]];
        NSURL *url = [NSURL URLWithString:baseStr];
        [[UIApplication sharedApplication] openURL:url];
    } error:NULL];
}
@end
