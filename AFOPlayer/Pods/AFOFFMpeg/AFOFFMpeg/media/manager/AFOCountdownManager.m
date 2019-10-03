//
//  AFOMediaQueueManager.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/31.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOCountdownManager.h"
#import <AFOGitHub/AFOGitHub.h>
#import <AFOFoundation/AFOFoundation.h>
@interface AFOCountdownManager ()
@property (nonatomic, strong)     dispatch_source_t    sourceTimer;
@end


@implementation AFOCountdownManager
#pragma mark ------------ init
- (instancetype)init{
    if (self = [super init]) {
        [INTUAutoRemoveObserver addObserver:self selector:@selector(AFOMediaQueueManagerTimerNotifaction:) name:NSStringFromSelector(@selector(AFOMediaQueueManagerTimerNotifaction:)) object:nil];
        ///------
        [INTUAutoRemoveObserver addObserver:self selector:@selector(AFOMediaQueueManagerTimerCancel) name:NSStringFromSelector(@selector(AFOMediaQueueManagerTimerCancel)) object:nil];
    }
    return self;
}
- (void)AFOMediaQueueManagerTimerNotifaction:(NSNotification *)object{
    NSNumber *number = object.object;
    if ([object.object isKindOfClass:[NSNumber class]]) {
        BOOL isPause = [number boolValue];
        if (isPause) {
            if (_sourceTimer) {
                dispatch_suspend(_sourceTimer);
            }
        }else{
            if (_sourceTimer) {
                dispatch_resume(_sourceTimer);
            }
        }
    }
}
- (void)AFOMediaQueueManagerTimerCancel{
    if (_sourceTimer) {
        dispatch_source_cancel(_sourceTimer);
    }
}
#pragma mark ------------ custom
#pragma mark ------ 倒计时
- (void)addCountdownActionFps:(float)fps
                     duration:(int64_t)time
                        block:(void (^)(NSNumber *isEnd))block{
    __block int timeout = time * fps;
    if (fps / 100 >= 1) {
        fps = fps / 100;
    }
    dispatch_source_set_timer(self.sourceTimer,dispatch_walltime(NULL, 0),(1.0 / fps) * NSEC_PER_SEC, 0); //每秒执行
    WeakObject(self);
    dispatch_source_set_event_handler(self.sourceTimer, ^{
        StrongObject(self);
        if(timeout <= 0){ //倒计时结束，关闭
            block(@(YES));
            dispatch_source_cancel(self.sourceTimer);
        } else {
            timeout--;
            block(@(NO));
        }
    });
    dispatch_resume(self.sourceTimer);
}
#pragma mark ------------ property
- (dispatch_source_t)sourceTimer{
    if (!_sourceTimer) {
        _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    }
    return _sourceTimer;
}
- (void)dealloc{
    NSLog(@"AFOMediaQueueManager dealloc");
}
@end
