//
//  AFOAudioCache.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/7.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioCache.h"
#import "AFOAudioQueue.h"

#define AFO_DEFAULT_MEDIACACHE_CAP_ZERO     0
#define AFO_DEFAULT_MEDIACACHE_CAP          80
#define AFO_DEFAULT_MEDIACACHE_MARK_CAP     2
#define AFO_DEFAULT_MEDIACACHE_TIMEOUT      1.0

@interface AFOAudioCache ()
@property (nonatomic, assign) NSInteger      capacity;
@property (nonatomic, assign) NSInteger      markCapacity;
@property (nonatomic, assign) NSTimeInterval timeOut;
@property (nonnull, nonatomic, strong) AFOAudioQueue *audioQueue;
@end

@implementation AFOAudioCache
#pragma mark ------ init
- (instancetype)init{
    if (self = [super init]) {
        _capacity = AFO_DEFAULT_MEDIACACHE_CAP;
        _markCapacity = AFO_DEFAULT_MEDIACACHE_MARK_CAP;
        _timeOut = AFO_DEFAULT_MEDIACACHE_TIMEOUT;
    }
    return self;
}
- (instancetype)initWithCap:(NSInteger)cap
                    markCap:(NSInteger)markCap
                    timeout:(NSTimeInterval)timeout{
    if (self = [super init]) {
        _capacity = cap;
        _markCapacity = markCap;
        _timeOut = timeout;
    }
    return self;
}
#pragma mark ------ attribute
- (AFOAudioQueue *)audioQueue{
    if (!_audioQueue) {
        _audioQueue = [[AFOAudioQueue alloc] init];
    }
    return _audioQueue;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOAudioCache dealloc");
}
@end
