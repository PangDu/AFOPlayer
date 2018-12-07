//
//  AFOPlayMediaController.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/28.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMediaPlayController.h"
#import "AFOMediaPlayControllerCategory.h"
#import "AFOVideoAudioManager.h"
#import "AFOPlayMediaManager.h"
#import "AFOMediaDecoder.h"
#import "AFOMediaOpenGLView.h"
#import "AFOAudioManager.h"
@interface AFOMediaPlayController ()<AFORouterManagerDelegate>
@property (nonatomic, strong) AFOPlayMediaManager        *mediaManager;
@property (nonatomic, strong) AFOMediaDecoder            *mediaInstance;
@property (nonatomic, copy)   NSString                   *strPath;
@property (nonatomic, assign) UIInterfaceOrientationMask  orientation;
@property (nonatomic, strong) AFOMediaOpenGLView         *openGLView;
@end

@implementation AFOMediaPlayController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self settingControllerOrientation];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFOMediaQueueManagerTimerCancel" object:nil];
    ///---
    [[AFOVideoAudioManager shareVideoAudioManager] stopAudio];
}
#pragma mark ------------ viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.openGLView];
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
//    WeakObject(self);
//    [self.mediaInstance displayVedioPath:path block:^(AFOVideoFrame *videoFrame) {
//        StrongObject(self);
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
////            [self.opemGLView displayYUV420pData:data width:self.view.frame.size.width height:self.view.frame.size.height];
//        }];
//    }];
    ///------
    WeakObject(self);
    [[AFOVideoAudioManager shareVideoAudioManager] displayVedioForPath:path block:^(NSError * _Nullable error, UIImage * _Nullable image, NSString * _Nullable totalTime, NSString * _Nullable currentTime, NSInteger totalSeconds, NSUInteger cuttentSeconds) {
        StrongObject(self);
        if (!error.code) {
            [self settingMeidaViewImage:image totalTime:totalTime currentTime:currentTime total:totalSeconds current:cuttentSeconds];
        }
    }];
    ///
    [[AFOVideoAudioManager shareVideoAudioManager] playAudio];
}
#pragma mark ------------ system
#pragma mark ------
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
    // Dispose of any resources that can be recreated.
}
#pragma mark ------------ property
#pragma mark ------ viewModel
- (AFOPlayMediaManager *)mediaManager{
    if (!_mediaManager){
        _mediaManager = [[AFOPlayMediaManager alloc] init];
    }
    return _mediaManager;
}
- (AFOMediaDecoder *)mediaInstance{
    if (!_mediaInstance) {
        _mediaInstance = [[AFOMediaDecoder alloc] init];
    }
    return _mediaInstance;
}
- (AFOMediaOpenGLView *)openGLView{
    if (!_openGLView) {
        _openGLView = [[AFOMediaOpenGLView alloc] initWithFrame:self.view.bounds];
    }
    return _openGLView;
}
- (void)dealloc{
    NSLog(@"dealloc AFOMediaPlayController");
}
@end
