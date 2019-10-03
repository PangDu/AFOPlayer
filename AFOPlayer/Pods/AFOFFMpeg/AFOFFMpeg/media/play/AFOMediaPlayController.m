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
#import "AFOMediaPlayControllerCategory.h"
#import "AFOVideoAudioManager.h"
@interface AFOMediaPlayController ()<AFORouterManagerDelegate>
@property (nonatomic, strong) AFOVideoAudioManager       *mediaManager;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaStopManager" object:nil];
}
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark ------
- (void)viewWillLayoutSubviews{
   [self addMeidaView];
}
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model{
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
- (AFOVideoAudioManager *)mediaManager{
    if (!_mediaManager){
        _mediaManager = [[AFOVideoAudioManager alloc] init];
    }
    return _mediaManager;
}
- (void)dealloc{
    NSLog(@"AFOMediaPlayController dealloc");
}
@end
