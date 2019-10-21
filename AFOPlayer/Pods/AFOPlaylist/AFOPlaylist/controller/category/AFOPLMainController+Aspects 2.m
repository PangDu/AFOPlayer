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
#import "AFOPLMainControllerCategory.h"
@implementation AFOPLMainController (Aspects)
#pragma mark ------ collectionView:didSelectItemAtIndexPath:
- (void)collectionViewDidSelectRowAtIndexPathExchange{
    [self aspect_hookSelector:@selector(collectionView:didSelectItemAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:base]];
    } error:NULL];
}
@end
