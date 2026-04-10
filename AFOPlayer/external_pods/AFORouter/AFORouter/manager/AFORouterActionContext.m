//
//  AFORouterActionContext.m
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFORouterActionContext.h"
#import "AFORouterTypeAction.h"
@interface AFORouterActionContext ()
@property (nonatomic, strong)           NSDictionary *actionDic;
@property (nonatomic, strong)    AFORouterTypeAction *action;
@end

@implementation AFORouterActionContext
- (void)passingCurrentController:(UIViewController *)current
                  nextController:(NSString *)next
                      parameters:(NSDictionary *)paramenter{
    NSString *strAction = paramenter[@"action"];
    Class class = NSClassFromString(self.actionDic[strAction]);
    self.action = [[class alloc] init];
    if ([self.action respondsToSelector:@selector(currentController:nextController: parameter:)]) {
        [self.action currentController:current nextController:next parameter:paramenter];
    }
}
#pragma mark ------ property
- (AFORouterTypeAction *)action{
    if (!_action) {
        _action = [[AFORouterTypeAction alloc] init];
    }
    return _action;
}
- (NSDictionary *)actionDic{
    if (!_actionDic) {
        _actionDic = @{
                       @"push" : @"AFORouterPushAction",
                       @"present" : @"AFORouterPresentAction"
                       };
    }
    return _actionDic;
}
@end
