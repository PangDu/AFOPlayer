//
//  AFOAudioSampling.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioSampling.h"

@interface AFOAudioSampling (){
    AVFrame             *audioFrame;
    SwrContext          *swrContext;
}
@property (nonatomic, assign)            NSInteger       audioStream;
@property (nonatomic, assign)            float           audioTime;
@end

@implementation AFOAudioSampling
#pragma mark ------ init
+ (instancetype)shareAFOAudioSampling{
    static AFOAudioSampling *audioSampling;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioSampling = [[AFOAudioSampling alloc] init];
    });
    return audioSampling;
}
#pragma mark ------ add method
- (void)audioSamping:(nonnull AVFormatContext *)avFormatContext
        codecContext:(nonnull AVCodecContext *)avCodecContext
               codec:(nonnull AVCodec *)codec
               index:(NSInteger)index{
    self.audioStream = index;
    AVStream *audioStream =avFormatContext -> streams[self.audioStream];
    if (audioStream->time_base.den && audioStream->time_base.num) {
        self.audioTime = av_q2d(audioStream->time_base);
    }else if (audioStream->sample_aspect_ratio.den && audioStream->codecpar){
        self.audioTime = av_q2d(audioStream->codecpar->sample_aspect_ratio);
    }
    if (!(avCodecContext->sample_fmt == AV_SAMPLE_FMT_S16)) {
        swrContext = swr_alloc_set_opts(NULL,
                                        av_get_default_channel_layout(2),
                                        AV_SAMPLE_FMT_S16,
                                        audioStream->codecpar->sample_rate,
                                        av_get_default_channel_layout(audioStream->codecpar->channels),
                                        avCodecContext->sample_fmt,
                                        audioStream->codecpar->sample_rate,
                                        0,
                                        NULL);
        
        if (!swrContext || swr_init(swrContext)) {
            if (swrContext) {
                swr_free(&swrContext);
            }
        }
    }
    NSLog(@"channels is %d sampleRate is %d", audioStream->codecpar->channels, audioStream->codecpar->sample_rate);
}
#pragma mark ------ dealloc
- (void)dealloc{
    if (swrContext) {
        swr_free(&swrContext);
    }
}
@end