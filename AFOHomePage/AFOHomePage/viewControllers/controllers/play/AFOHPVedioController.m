//
//  AFOHPVedioController.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPVedioController.h"
#import "AFOHPAVPlayer.h"
#import "AFOHPAVPlayerView.h"
@interface AFOHPVedioController ()<AFORouterManagerDelegate,AFOHPAVPlayerViewDelegate>
@property (nonatomic, strong) AFOHPAVPlayer         *hpAVPlayer;
@property (nonatomic, strong) AFOHPAVPlayerView     *hpAVPlayerView;
@end

@implementation AFOHPVedioController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.hpAVPlayerView displayLinkPause];
}
#pragma mark ------------ custom
#pragma mark ------ AFORouterManagerDelegate
- (void)didReceiverRouterManagerDelegate:(id)model
                                        parameters:(NSDictionary *)parameters{
    self.title = [parameters objectForKey:@"title"];
    [self.hpAVPlayerView settingValue:model dictionary:parameters];
    [self.view addSubview:self.hpAVPlayerView];
}
#pragma mark ------ AFOHPAVPlayerViewDelegate
- (void)settingSongName:(NSString *)name{
    self.title = name;
}
#pragma mark ------------ system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------- property
- (AFOHPAVPlayer *)hpAVPlayer{
    if (!_hpAVPlayer) {
        _hpAVPlayer = [[AFOHPAVPlayer alloc] init];
    }
    return _hpAVPlayer;
}
#pragma mark ------
- (AFOHPAVPlayerView *)hpAVPlayerView{
    if (!_hpAVPlayerView) {
        _hpAVPlayerView = [[AFOHPAVPlayerView alloc] initWithFrame:self.view.bounds delegate:self];
    }
    return _hpAVPlayerView;
}
- (void)dealloc{
    NSLog(@"dealloc %@",NSStringFromClass([AFOHPVedioController class]));
}
@end
