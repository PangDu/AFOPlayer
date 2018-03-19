//
//  AFOHPListController+Router.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/27.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOHPListController+Router.h"
#import "AFOHPListViewModel.h"
@implementation AFOHPListController (Router)
- (void)tableViewdidSelectRowAtIndexPathExchange{
    [self aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        NSURL *url = [self.viewModel settingRouterUrl:indexPath];
        [[UIApplication sharedApplication] openURL:url];
    } error:NULL];
}
@end
