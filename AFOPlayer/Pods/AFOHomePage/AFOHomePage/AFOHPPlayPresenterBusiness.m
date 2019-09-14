//
//  AFOHPPlayPresenterBusiness.m
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPlayPresenterBusiness.h"
#import "AFOHPAVPlayer.h"
#import "AFOHPAVPlayer+ChooseSong.h"
@interface AFOHPPlayPresenterBusiness ()
@property (nonatomic, strong) AFOHPAVPlayer             *player;
@property (nonatomic, weak) id<AFOHPPlayPresenterBusinessDelegate>businessDelegate;
@end
@implementation AFOHPPlayPresenterBusiness
- (instancetype)initWithDelegate:(id<AFOHPPlayPresenterBusinessDelegate>)delegate{
    if (self = [super initWithDelegate:delegate]) {
        _businessDelegate = delegate;
    }
    return self;
}
#pragma mark ------ 
- (void)receiverRouterMessage:(id)model
                   parameters:(NSDictionary *)parameters{
    self.player.currentItem = [self.player getCurrentSongImage:model dictionary:parameters];
    [self.player addPlayerItem:[self.player getCurrentSongImage:model dictionary:parameters]];
}
- (void)musicPlayTimerCallBack:(void(^)(NSTimeInterval currentTime,
                                        NSTimeInterval totalTime))block{
    [self.player updateProgressSlider:^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
        if (currentTime >= totalTime) {
            [self.player selectMusicPlayer:AFOHPAVPlayerSelectMusicNext];
        }else{
            block(currentTime,totalTime);
        }
    }];
}
#pragma mark ------ 
- (void)musicPlayAction:(BOOL)isPlay{
    [self.player settingAVPlayerPause:isPlay];
}
#pragma mark ------ AFOHPAVPlayerDelegate
- (void)audioTotalTime:(NSString *)totalTime{
    
}
- (void)audioPlayWithEnter{
    [self.player selectMusicPlayer:0];
    [self.businessDelegate passTotalTime:[self.player totalTimer]];
}
- (void)audioOperationPlay:(id)model{
    
}
#pragma mark ------ property
- (AFOHPAVPlayer *)player{
    if (!_player) {
        _player = [[AFOHPAVPlayer alloc] initWithDelegate:self];
    }
    return _player;
}
@end
