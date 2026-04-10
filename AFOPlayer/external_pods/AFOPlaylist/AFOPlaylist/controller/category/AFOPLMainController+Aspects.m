//
//  AFOPLMainController+Aspects.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainController+Aspects.h"
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFOSchedulerCore/AFOSchedulerBaseClass+AFOPlayList.h>
#import <AFOSchedulerCore/AFOSchedulerBaseClass+AFORouter.h>
#import "AFOPLMainControllerCategory.h"
@implementation AFOPLMainController (Aspects)
#pragma mark ------ collectionView:didSelectItemAtIndexPath:
- (void)collectionViewDidSelectRowAtIndexPathExchange{
    [self aspect_hookSelector:@selector(collectionView:didSelectItemAtIndexPath:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        NSLog(@"AFOPLMainController+Aspects: collectionView:didSelectItemAtIndexPath: hooked and block executed.");
        NSString *path = [self vedioPath:indexPath];
        NSString *name = [self vedioName:indexPath];
        NSInteger screen = [self screenPortrait:indexPath];
        
        NSDictionary *dictionary = @{
                                     @"modelName" :   @"playlist",
                                     @"current" : NSStringFromClass([self class]),
                                     @"next" : @"AFOMediaPlayController",
                                     @"action" :@"push",
                                     @"value" : path,
                                     @"title" : name,
                                     @"direction" : @(screen)
                                     };
        NSString *base = [NSString settingRoutesParameters:dictionary];
        [AFOSchedulerBaseClass schedulerRouterJumpPassingParameters:dictionary];
    } error:NULL];
}
@end
