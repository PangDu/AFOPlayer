//
//  AFOHPDetailController+Router.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPDetailController+Router.h"
#import "AFOHPDetailViewModel.h"
@implementation AFOHPDetailController (Router)
#pragma mark ------------- add property
#pragma mark ------ hpDetailArray
- (void)setHpDetailArray:(NSMutableArray *)hpDetailArray{
    objc_setAssociatedObject(self, @selector(setHpDetailArray:), hpDetailArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableArray *)hpDetailArray{
   return  objc_getAssociatedObject(self, @selector(setHpDetailArray:));
}
#pragma mark ------ userSelectBlock
- (void)setSelectNumber:(NSNumber *)selectNumber{
    objc_setAssociatedObject(self, @selector(setSelectNumber:), selectNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)selectNumber{
    return  objc_getAssociatedObject(self, @selector(setSelectNumber:));
}
#pragma mark ------------ tableView:didSelectRowAtIndexPath:
- (void)tableViewdidSelectRowAtIndexPathExchange{
    __weak __typeof(self) weakSelf = self;
    [self aspect_hookSelector:@selector(tableView:didSelectRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, UITableView *tableView, NSIndexPath *indexPath){
        weakSelf.selectNumber = @(indexPath.item);
        [AFOHPDetailViewModel routerParams:self.hpDetailArray indexPath:indexPath block:^(NSURL *url) {
           [[UIApplication sharedApplication] openURL:url];
        }];
    } error:NULL];
}
@end
