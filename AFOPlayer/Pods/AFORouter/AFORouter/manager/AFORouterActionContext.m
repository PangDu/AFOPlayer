//
//  AFORouterActionContext.m
//  AFORouter
//
//  Created by xianxueguang on 2019/10/1.
//  Copyright © 2019年 AFO. All rights reserved.
//

#import "AFORouterActionContext.h"
#import "AFORouterTypeAction.h"
@interface AFORouterActionContext ()
@property (nonatomic, copy) NSString *strAction;
@property (nonatomic, strong) NSDictionary *actionDic;
@property (nonatomic, strong) AFORouterTypeAction *action;
@end

@implementation AFORouterActionContext
- (instancetype)initAction:(NSString*)strAction{
    if (self = [super init]) {
        _strAction = strAction;
    }
    return self;
}
- (void)currentController:(UIViewController *)current
           nextController:(UIViewController *)next
                parameter:(nonnull NSDictionary *)paramenter{
    Class class = NSClassFromString(self.actionDic[self.strAction]);
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
