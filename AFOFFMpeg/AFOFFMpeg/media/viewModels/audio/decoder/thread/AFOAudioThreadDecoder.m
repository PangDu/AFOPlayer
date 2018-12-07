//
//  AFOAudioThreadDecoder.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/7.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioThreadDecoder.h"
#import "AFOAudioDecoder.h"
#import "AFOAudioCache.h"
#import "AFOAudioPacket.h"
#define CHANNEL_PER_FRAME    2
#define BITS_PER_CHANNEL     16
#define BITS_PER_BYTE        8
@interface AFOAudioThreadDecoder()
@property (nonatomic, assign) int       audioSampleRate;
@property (nonatomic, assign) int       packetBufferSize;
@property (nonatomic, assign) float     playPosition;
@property (nonatomic, assign) float     timePercent;
@property (nonnull, nonatomic, strong) AFOAudioDecoder  *audioDecoder;
@property (nonnull, nonatomic, strong) AFOAudioPacket   *audioPacket;
@property (nonnull, nonatomic, strong) AFOAudioCache    *audioCache;
@end

@implementation AFOAudioThreadDecoder
#pragma mark ------ init
- (instancetype)init{
    if (self = [super init]) {
        _playPosition = 0.0f;
    }
    return self;
}
#pragma mark ------ method
- (void)packetBufferTimePercent:(float)timePercent{
    self.timePercent = timePercent;
}
- (void)createBaseData:(int)sampleRate{
    _audioSampleRate = sampleRate;
    int audioByteCountPerSec = _audioSampleRate * CHANNEL_PER_FRAME * BITS_PER_CHANNEL / BITS_PER_BYTE;
    _packetBufferSize = (int)( ( audioByteCountPerSec / 2 ) * self.timePercent);
}
- (void)audioDecoder:(nonnull AVFormatContext *)avFormatContext
        codecContext:(nonnull AVCodecContext *)avCodecContext
               codec:(nonnull AVCodec *)codec
               index:(NSInteger)index{
    [self createBaseData:avCodecContext -> sample_rate];
    ///---
    [self.audioDecoder audioDecoder:avFormatContext codecContext:avCodecContext codec:codec index:index packetSize:_packetBufferSize];
    ///---
    [self threadDecoderAudio];
}
- (void)threadDecoderAudio{
//    while (self.audioCache.getQueueCount < self.audioCache.capacity) {
//        STAudioLocalPacket *packet = [_deCoder decodePacket];
//        [self.audioCache publish:packet];
//        //        NSLog(@"🐲---------%lu", (unsigned long)self.audioCache.getQueueCount);
//    }
}
- (void)readAudioPacket:(short *)samples size:(int)size{
    [self.audioDecoder readAudioSamples:samples size:size];
}
#pragma mark ------ attribute
- (AFOAudioDecoder *)audioDecoder{
    if (!_audioDecoder) {
        _audioDecoder = [[AFOAudioDecoder alloc] init];
    }
    return _audioDecoder;
}
- (AFOAudioCache *)audioCache{
    if (!_audioCache) {
        _audioCache = [[AFOAudioCache alloc] initWithCap:self.audioSampleRate / 1024 markCap:0 timeout:1.0];
    }
    return _audioCache;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOAudioThreadDecoder dealloc");
}
@end
