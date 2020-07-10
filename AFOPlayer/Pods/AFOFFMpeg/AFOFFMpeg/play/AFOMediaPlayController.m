//
//  AFOPlayMediaController.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/28.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMediaPlayController.h"
#import <AFORouter/AFORouter.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFOGitHub/INTUAutoRemoveObserver.h>
#import <AFOSchedulerCore/AFOSchedulerPassValueDelegate.h>
#import "AFOMediaPlayControllerCategory.h"
#import "AFOTotalDispatchManager.h"
@interface AFOMediaPlayController ()<AFOSchedulerPassValueDelegate>
@property (nonatomic, strong) AFOTotalDispatchManager       *mediaManager;
@property (nonatomic, copy)   NSString                   *strPath;
@property (nonatomic, assign) UIInterfaceOrientationMask  orientation;
@end

@implementation AFOMediaPlayController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self settingControllerOrientation];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaQueueManagerTimerCancel" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaSuspendedManager" object:nil];
}
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [INTUAutoRemoveObserver addObserver:self selector:@selector(restartMediaFile) name:@"AFORestartMeidaFileNotification" object:nil];
}
#pragma mark ------
- (void)viewWillLayoutSubviews{
   [self addMeidaView];
}
- (void)restartMediaFile{
    [self playerVedioWithPath:self.strPath];
}
#pragma mark ------ AFOSchedulerPassValueDelegate
- (void)schedulerReceiverRouterManagerDelegate:(id)model{
    NSDictionary *parameters = model;
    NSString *value = parameters[@"value"];
    self.orientation = [[parameters objectForKey:@"direction"] integerValue];
    self.strPath = value;
    self.title = parameters[@"title"];
    [self playerVedioWithPath:value];
}
#pragma mark ------
- (void)playerVedioWithPath:(NSString *)path{
    WeakObject(self);
    [self.mediaManager displayVedioForPath:path block:^(NSError * _Nullable error, UIImage * _Nullable image, NSString * _Nullable totalTime, NSString * _Nullable currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
        StrongObject(self);
        if (!error.code) {
            [self settingMeidaViewImage:image totalTime:totalTime currentTime:currentTime total:totalSeconds current:cuttentSeconds];
        }
    }];
}
#pragma mark ------------ system
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.orientation;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark ------ didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark ------------ property
- (AFOTotalDispatchManager *)mediaManager{
    if (!_mediaManager){
        _mediaManager = [[AFOTotalDispatchManager alloc] init];
    }
    return _mediaManager;
}
- (void)dealloc{
    NSLog(@"AFOMediaPlayController dealloc");
}
@end
