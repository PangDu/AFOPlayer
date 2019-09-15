//
//  AFOAudioSampling.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioDecoder.h"
#define STMAX(a, b)  (((a) > (b)) ? (a) : (b))
#define STMIN(a, b)  (((a) < (b)) ? (a) : (b))
@interface AFOAudioDecoder (){
    AVFormatContext     *formatContext;
    AVCodecContext      *codecContext;
    AVFrame             *avFrame;
    SwrContext          *swrContext;
    void                *swrBuffer;
    short               *audioBuffer;
    AVPacket             packet;
}
@property (nonatomic, assign)            NSInteger       audioStream;
@property (nonatomic, assign)            CGFloat         audioTimeBase;
@property (nonatomic, assign)            float           audioClock;
@property (nonatomic, assign)            int             swrBufferSize;
@property (nonatomic, assign)            int             audioBufferCursor;
@property (nonatomic, assign)            int             audioBufferSize;
@property (nonatomic, assign)            int             packetBufferSize;
@end

@implementation AFOAudioDecoder
#pragma mark ------ init
- (instancetype)init{
    if (self = [super init]) {
        avFrame = av_frame_alloc();
    }
    return self;
}
#pragma mark ------ add method
- (void)audioDecoder:(nonnull AVFormatContext *)avFormatContext
        codecContext:(nonnull AVCodecContext *)avCodecContext
               index:(NSInteger)index
          packetSize:(int)packetSize{
    formatContext = avFormatContext;
    codecContext = avCodecContext;
    self.audioStream = index;
    ///---
    AVStream *audioStream =formatContext -> streams[self.audioStream];
    if (!(codecContext->sample_fmt == AV_SAMPLE_FMT_S16)) {
        swrContext = swr_alloc_set_opts(NULL,
                                        av_get_default_channel_layout(2),
                                        AV_SAMPLE_FMT_S16,
                                        audioStream->codecpar->sample_rate,
                                        av_get_default_channel_layout(audioStream->codecpar->channels),
                                        codecContext->sample_fmt,
                                        audioStream->codecpar->sample_rate,
                                        0,
                                        NULL);
        
        if (!swrContext || swr_init(swrContext)) {
            if (swrContext) {
                swr_free(&swrContext);
            }
        }
        AVStream *st = formatContext->streams[self.audioStream];
        avStreamFPSTimeBase(st, 0.04, 0, &_audioTimeBase);
    }
}
- (int)readAudioSamples:(short *)samples
                   size:(int)size
                  block:(audioTimeStampBlock)block{
    int samplesSize = size;
    while (size > 0) {
        if (_audioBufferCursor < _audioBufferSize) {
            int audioBufferDataSize = _audioBufferSize - _audioBufferCursor;
            int copySize = STMIN(size, audioBufferDataSize);
            memcpy(samples + (samplesSize - size), audioBuffer + _audioBufferCursor, copySize * 2);
            size -= copySize;
            _audioBufferCursor += copySize;
        }else{
            if ([self decodeAudioFrame:^(float timeStamp) {
                block(timeStamp);
            }] < 0) {
                break;
            }
        }
    }
    int fillSize = samplesSize - size;
    if (fillSize == 0) {
        return -1;
    }
    return fillSize;
}
#pragma mark ------
- (NSInteger)decodeAudioFrame:(audioTimeStampBlock)block{
    int ret = 1;
    av_init_packet(&packet);
    int gotFrame = 0;
    int readFrameCode = -1;
    
    while (1) {
        readFrameCode = av_read_frame(formatContext, &packet);
        if (readFrameCode >= 0) {
            if (packet.stream_index == self.audioStream) {
                int ret = avcodec_send_packet(codecContext, &packet);
                if (ret < 0 && ret != AVERROR(EAGAIN) && ret != AVERROR_EOF){
                    return -1;
                }
                ret = avcodec_receive_frame(codecContext, avFrame);
                if (ret < 0 && ret != AVERROR(EAGAIN) && ret != AVERROR_EOF) {
                    return -1;
                }else{
                    gotFrame = 1;
                }
                ///---
                if (gotFrame) {
                    int numChannels = 2;
                    int numFrames = 0;
                    void *audioData;
                    if (swrContext) {
                        const int ratio = 2;
                        const int bufSize = av_samples_get_buffer_size(NULL,
                                                                       numChannels,
                                                                       avFrame->nb_samples * ratio,
                                                                       AV_SAMPLE_FMT_S16,
                                                                       1);
                        if (!swrBuffer || _swrBufferSize < bufSize) {
                            _swrBufferSize = bufSize;
                            swrBuffer = realloc(swrBuffer, _swrBufferSize);
                        }
                        Byte *outbuf[2] = {(Byte *) swrBuffer, NULL};
                        numFrames = swr_convert(swrContext,
                                                outbuf,
                                                avFrame->nb_samples *ratio,
                                                (const uint8_t **)avFrame->data,
                                                avFrame->nb_samples);
                        if (numFrames < 0) {
                            NSLog(@"fail resample audio");
                            ret = -1;
                            break;
                        }
                        audioData = swrBuffer;
                    }else{
                        if (codecContext->sample_fmt != AV_SAMPLE_FMT_S16) {
                            NSLog(@"bucheck, audio format is invalid");
                            ret = -1;
                            break;
                        }
                        audioData = avFrame->data[0];
                        numFrames = avFrame->nb_samples;
                    }
                    _audioBufferSize = numFrames * numChannels;
                    audioBuffer = (short *)audioData;
                    _audioBufferCursor = 0;
//                    self.audioClock = packet.pts * av_q2d(formatContext->streams[self.audioStream]->time_base);
                    break;
                }
            }
        }else{
            ret = -1;
            break;
        }
    }
    av_packet_unref(&packet);
    return ret;
}
#pragma mark ------ C language method
static void avStreamFPSTimeBase(AVStream *st, CGFloat defaultTimeBase, CGFloat *pFPS, CGFloat *pTimeBase){
    CGFloat fps, timebase;
    // ffmpeg提供了一个把AVRatioal结构转换成double的函数
    // 默认0.04 意思就是25帧
    if (st->time_base.den && st->time_base.num){
        timebase = av_q2d(st->time_base);
    }else if(st->codecpar->sample_aspect_ratio.den && st->codecpar->sample_aspect_ratio.num){
        timebase = av_q2d(st->codecpar->sample_aspect_ratio);
    }else{
        timebase = defaultTimeBase;
    }
    // 平均帧率
    if (st->avg_frame_rate.den && st->avg_frame_rate.num){
        fps = av_q2d(st->avg_frame_rate);
    }else if (st->r_frame_rate.den && st->r_frame_rate.num){
        fps = av_q2d(st->r_frame_rate);
    }else{
        fps = 1.0 / timebase;
    }
    if (pFPS){
        *pFPS = fps;
    }
    if (pTimeBase){
        *pTimeBase = timebase;
    }
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFAudioDecoder dealloc");
    if (swrContext) {
        swr_free(&swrContext);
        swrContext = NULL;
    } 
    if (avFrame) {
        av_free(avFrame);
        avFrame = NULL;
    }
}
@end
