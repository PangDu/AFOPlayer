//
//  AFOHPVedioController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPVedioController.h"
#import <AFORouter/AFORouter.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFOSchedulerCore/AFOSchedulerPassValueDelegate.h>
#import "AFOHPPlayPresenterView.h"
#import "AFOHPPlayPresenterBusiness.h"
@interface AFOHPVedioController ()<AFOHPPresenterDelegate,AFOHPPlayPresenterViewDelegate,AFOHPPlayPresenterBusinessDelegate,AFOSchedulerPassValueDelegate>
@property (nonatomic, strong) AFOHPPlayPresenterView     *presenterView;
@property (nonatomic, strong) AFOHPPlayPresenterBusiness *pressenterBusiness;
@end

@implementation AFOHPVedioController
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenterView bindingPlayerView];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)schedulerReceiverRouterManagerDelegate:(id)model
                                    parameters:(NSDictionary *)parameters{
    self.title = [parameters objectForKey:@"title"];
    [self.pressenterBusiness receiverRouterMessage:model parameters:parameters];
}
#pragma mark ------ AFOHPPresenterDelegate
- (void)bindingView:(UIView *)view{
    [self.view addSubview:view];
}
#pragma mark ------ AFOHPPlayPresenterViewDelegate
- (void)musicPlayActionDelegate:(BOOL)isPlay{
    [self.pressenterBusiness musicPlayAction:isPlay];
}
- (void)updateProgressSliderDelegate{
    WeakObject(self);
    [self.pressenterBusiness musicPlayTimerCallBack:^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        StrongObject(self);
        [self.presenterView setttingPlayTimer:currentTime totalTime:totalTime];
    }];
}
#pragma mark ------ AFOHPPlayPresenterBusinessDelegate
- (void)passTotalTime:(NSString *)totalTime{
    [self.presenterView settingTotalTime:totalTime];
}
#pragma mark ------------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- property
- (AFOHPPresenter *)presenterView{
    if (!_presenterView) {
        _presenterView = [[AFOHPPlayPresenterView alloc] initWithDelegate:self];
    }
    return _presenterView;
}
- (AFOHPPresenter *)pressenterBusiness{
    if (!_pressenterBusiness) {
        _pressenterBusiness = [[AFOHPPlayPresenterBusiness alloc] initWithDelegate:self];
    }
    return _pressenterBusiness;
}
- (void)dealloc{
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPVedioController class]));
}
@end
