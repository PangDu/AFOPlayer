//
//  KxMovieDecoder.m
//  kxmovie
//
//  Created by Kolyvan on 15.10.12.
//  Copyright (c) 2012 Konstantin Boukreev . All rights reserved.
//
//  https://github.com/kolyvan/kxmovie
//  this file is part of KxMovie
//  KxMovie is licenced under the LGPL v3, see lgpl-3.0.txt

#import "KxMovieDecoder.h"
#import "KxMovieDecoderStatic.h"
#pragma mark ------------------ KxMovieFrame
@interface KxMovieFrame()
@property (readwrite, nonatomic) CGFloat position;
@property (readwrite, nonatomic) CGFloat duration;
@end

@implementation KxMovieFrame
@end
#pragma mark ------------------ KxAudioFrame
@interface KxAudioFrame()
@property (readwrite, nonatomic, strong) NSData *samples;
@end

@implementation KxAudioFrame
- (KxMovieFrameType) type { return KxMovieFrameTypeAudio; }
@end
#pragma mark ------------------ KxVideoFrame
@interface KxVideoFrame()
@property (readwrite, nonatomic) NSUInteger width;
@property (readwrite, nonatomic) NSUInteger height;
@end

@implementation KxVideoFrame
- (KxMovieFrameType) type { return KxMovieFrameTypeVideo; }
@end
#pragma mark ------------------ KxVideoFrameRGB
@interface KxVideoFrameRGB ()
@property (readwrite, nonatomic) NSUInteger linesize;
@property (readwrite, nonatomic, strong) NSData *rgb;
@end

@implementation KxVideoFrameRGB
- (KxVideoFrameFormat) format {
    return KxVideoFrameFormatRGB;
}
- (UIImage *) asImage{
    UIImage *image = nil;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(_rgb));
    if (provider) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace) {
            CGImageRef imageRef = CGImageCreate(self.width,
                                                self.height,
                                                8,
                                                24,
                                                self.linesize,
                                                colorSpace,
                                                kCGBitmapByteOrderDefault,
                                                provider,
                                                NULL,
                                                YES, // NO
                                                kCGRenderingIntentDefault);
            
            if (imageRef) {
                image = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
            }
            CGColorSpaceRelease(colorSpace);
        }
        CGDataProviderRelease(provider);
    }
    
    return image;
}
@end
#pragma mark ------------------ KxVideoFrameYUV
@interface KxVideoFrameYUV()
@property (readwrite, nonatomic, strong) NSData *luma;
@property (readwrite, nonatomic, strong) NSData *chromaB;
@property (readwrite, nonatomic, strong) NSData *chromaR;
@end

@implementation KxVideoFrameYUV
- (KxVideoFrameFormat) format { return KxVideoFrameFormatYUV; }
@end
#pragma mark ------------------ KxArtworkFrame
@interface KxArtworkFrame()
@property (readwrite, nonatomic, strong) NSData *picture;
@end

@implementation KxArtworkFrame
- (KxMovieFrameType) type {
    return KxMovieFrameTypeArtwork;
}
- (UIImage *) asImage{
    UIImage *image = nil;
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)(_picture));
    if (provider) {
        
        CGImageRef imageRef = CGImageCreateWithJPEGDataProvider(provider,
                                                                NULL,
                                                                YES,
                                                                kCGRenderingIntentDefault);
        if (imageRef) {
            
            image = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
        }
        CGDataProviderRelease(provider);
    }
    
    return image;

}
@end
#pragma mark ------------------ KxSubtitleFrame
@interface KxSubtitleFrame()
@property (readwrite, nonatomic, strong) NSString *text;
@end

@implementation KxSubtitleFrame
- (KxMovieFrameType) type { return KxMovieFrameTypeSubtitle; }
@end
#pragma mark ---------------------------------- KxMovieDecoder
@interface KxMovieDecoder () {
    AVFormatContext     *_formatCtx;
	AVCodecContext      *_videoCodecCtx;
    AVCodecContext      *_audioCodecCtx;
    AVCodecContext      *_subtitleCodecCtx;
    AVFrame             *_videoFrame;
    AVFrame             *_audioFrame;
    NSInteger           _videoStream;
    NSInteger           _audioStream;
    NSInteger           _subtitleStream;
	AVPicture           _picture;
    BOOL                _pictureValid;
    struct SwsContext   *_swsContext;
    CGFloat             _videoTimeBase;
    CGFloat             _audioTimeBase;
    CGFloat             _position;
    NSArray             *_videoStreams;
    NSArray             *_audioStreams;
    NSArray             *_subtitleStreams;
    SwrContext          *_swrContext;
    void                *_swrBuffer;
    NSUInteger          _swrBufferSize;
    NSDictionary        *_info;
    KxVideoFrameFormat  _videoFrameFormat;
    NSUInteger          _artworkStream;
    NSInteger           _subtitleASSEvents;
}
@end
@implementation KxMovieDecoder
@dynamic duration;
@dynamic position;
@dynamic frameWidth;
@dynamic frameHeight;
@dynamic sampleRate;
@dynamic audioStreamsCount;
@dynamic subtitleStreamsCount;
@dynamic selectedAudioStream;
@dynamic selectedSubtitleStream;
@dynamic validAudio;
@dynamic validVideo;
@dynamic validSubtitles;
@dynamic info;
@dynamic videoStreamFormatName;
@dynamic startTime;
#pragma mark - init
+ (void)initialize{
    av_log_set_callback(FFLog);
    av_register_all();
    avformat_network_init();
}
+ (id) movieDecoderWithContentPath: (NSString *) path
                             error: (NSError **) perror{
    KxMovieDecoder *mp = [[KxMovieDecoder alloc] init];
    if (mp) {
        [mp openFile:path error:perror];
    }
    return mp;
}
#pragma mark - private

- (BOOL)openFile: (NSString *) path
        error: (NSError **) perror{
    NSAssert(path, @"nil path");
    NSAssert(!_formatCtx, @"already open");
    
    _isNetwork = isNetworkPath(path);
    
    static BOOL needNetworkInit = YES;
    if (needNetworkInit && _isNetwork) {
        
        needNetworkInit = NO;
        avformat_network_init();
    }
    _path = path;
    kxMovieError errCode = [self openInput: path];
    if (errCode == kxMovieErrorNone) {
        kxMovieError videoErr = [self openVideoStream];
        kxMovieError audioErr = [self openAudioStream];
        _subtitleStream = -1;
        
        if (videoErr != kxMovieErrorNone &&
            audioErr != kxMovieErrorNone) {
            errCode = videoErr; // both fails
        } else {
            _subtitleStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_SUBTITLE);
        }
    }
    
    if (errCode != kxMovieErrorNone) {
        
        [self closeFile];
        NSString *errMsg = errorMessage(errCode);
        LoggerStream(0, @"%@, %@", errMsg, path.lastPathComponent);
        if (perror)
            *perror = kxmovieError(errCode, errMsg);
        return NO;
    }
        
    return YES;
}

- (kxMovieError) openInput: (NSString *) path{
    AVFormatContext *formatCtx = NULL;
    if (_interruptCallback) {
        formatCtx = avformat_alloc_context();
        if (!formatCtx)
            return kxMovieErrorOpenFile;
        
        AVIOInterruptCB cb = {
            interrupt_callback, (__bridge void *)(self)
        };
        formatCtx->interrupt_callback = cb;
    }
    if (avformat_open_input(&formatCtx, [path cStringUsingEncoding: NSUTF8StringEncoding], NULL, NULL) < 0) {
        if (formatCtx)
            avformat_free_context(formatCtx);
        return kxMovieErrorOpenFile;
    }
    
    if (avformat_find_stream_info(formatCtx, NULL) < 0) {
        avformat_close_input(&formatCtx);
        return kxMovieErrorStreamInfoNotFound;
    }

    av_dump_format(formatCtx, 0, [path.lastPathComponent cStringUsingEncoding: NSUTF8StringEncoding], false);
    
    _formatCtx = formatCtx;
    return kxMovieErrorNone;
}
- (kxMovieError) openVideoStream{
    kxMovieError errCode = kxMovieErrorStreamNotFound;
    _videoStream = -1;
    _artworkStream = -1;
    _videoStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_VIDEO);
    for (NSNumber *n in _videoStreams) {
        const NSUInteger iStream = n.integerValue;
        if (0 == (_formatCtx->streams[iStream]->disposition & AV_DISPOSITION_ATTACHED_PIC)) {
            errCode = [self openVideoStream: iStream];
            if (errCode == kxMovieErrorNone)
                break;
        } else {
            _artworkStream = iStream;
        }
    }
    return errCode;
}

- (kxMovieError) openVideoStream: (NSInteger) videoStream{
    // get a pointer to the codec context for the video stream
    AVCodecContext *codecCtx = _formatCtx->streams[videoStream]->codec;
    
    // find the decoder for the video stream
    AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id);
    if (!codec)
        return kxMovieErrorCodecNotFound;
    
    // inform the codec that we can handle truncated bitstreams -- i.e.,
    // bitstreams where frame boundaries can fall in the middle of packets
    //if(codec->capabilities & CODEC_CAP_TRUNCATED)
    //    _codecCtx->flags |= CODEC_FLAG_TRUNCATED;
    
    // open codec
    if (avcodec_open2(codecCtx, codec, NULL) < 0)
        return kxMovieErrorOpenCodec;
        
    _videoFrame = av_frame_alloc();

    if (!_videoFrame) {
        avcodec_close(codecCtx);
        return kxMovieErrorAllocateFrame;
    }
    
    _videoStream = videoStream;
    _videoCodecCtx = codecCtx;
    
    // determine fps
    
    AVStream *st = _formatCtx->streams[_videoStream];
    avStreamFPSTimeBase(st, 0.04, &_fps, &_videoTimeBase);
    
    LoggerVideo(1, @"video codec size: %lu:%lu fps: %.3f tb: %f",
                self.frameWidth,
                self.frameHeight,
                _fps,
                _videoTimeBase);
    
    LoggerVideo(1, @"video start time %f", st->start_time * _videoTimeBase);
    LoggerVideo(1, @"video disposition %d", st->disposition);
    
    return kxMovieErrorNone;
}

- (kxMovieError) openAudioStream{
    kxMovieError errCode = kxMovieErrorStreamNotFound;
    _audioStream = -1;
    _audioStreams = collectStreams(_formatCtx, AVMEDIA_TYPE_AUDIO);
    for (NSNumber *n in _audioStreams) {
        errCode = [self openAudioStream: n.integerValue];
        if (errCode == kxMovieErrorNone)
            break;
    }    
    return errCode;
}

- (kxMovieError) openAudioStream: (NSInteger) audioStream{
    AVCodecParameters *codecParameters = _formatCtx->streams[audioStream]->codecpar;
    AVCodecContext *codecCtx = _formatCtx->streams[audioStream]->codec;
    SwrContext *swrContext = NULL;
    
    AVCodec *codec = avcodec_find_decoder(codecParameters->codec_id);
    if(!codec)
        return kxMovieErrorCodecNotFound;
        
    if (avcodec_open2(codecCtx, codec, NULL) < 0)
         return kxMovieErrorOpenCodec;
    
    if (!audioCodecIsSupported(codecCtx)) {

        id<KxAudioManager> audioManager = [KxAudioManager audioManager];
        swrContext = swr_alloc_set_opts(NULL,
                                        av_get_default_channel_layout(audioManager.numOutputChannels),
                                        AV_SAMPLE_FMT_S16,
                                        audioManager.samplingRate,
                                        av_get_default_channel_layout(codecParameters->channels),
                                        codecCtx->sample_fmt,
                                        codecParameters->sample_rate,
                                        0,
                                        NULL);
        
        if (!swrContext ||
            swr_init(swrContext)) {
            
            if (swrContext)
                swr_free(&swrContext);
             avcodec_close(codecCtx);

            return kxMovieErroReSampler;
        }
    }
    
    _audioFrame = av_frame_alloc();

    if (!_audioFrame) {
        if (swrContext)
            swr_free(&swrContext);
        avcodec_close(codecCtx);
        return kxMovieErrorAllocateFrame;
    }
    
    _audioStream = audioStream;
    _audioCodecCtx = codecCtx;
    _swrContext = swrContext;
    
    AVStream *st = _formatCtx->streams[_audioStream];
    avStreamFPSTimeBase(st, 0.025, 0, &_audioTimeBase);
    
    LoggerAudio(1, @"audio codec smr: %.d fmt: %d chn: %d tb: %f %@",
                _audioCodecCtx->sample_rate,
                _audioCodecCtx->sample_fmt,
                _audioCodecCtx->channels,
                _audioTimeBase,
                _swrContext ? @"resample" : @"");
    
    return kxMovieErrorNone; 
}

- (kxMovieError) openSubtitleStream: (NSInteger) subtitleStream
{
    AVCodecContext *codecCtx = _formatCtx->streams[subtitleStream]->codec;
    
    AVCodec *codec = avcodec_find_decoder(codecCtx->codec_id);
    if(!codec)
        return kxMovieErrorCodecNotFound;
    
    const AVCodecDescriptor *codecDesc = avcodec_descriptor_get(codecCtx->codec_id);
    if (codecDesc && (codecDesc->props & AV_CODEC_PROP_BITMAP_SUB)) {
        // Only text based subtitles supported
        return kxMovieErroUnsupported;
    }
    
    if (avcodec_open2(codecCtx, codec, NULL) < 0)
        return kxMovieErrorOpenCodec;
    
    _subtitleStream = subtitleStream;
    _subtitleCodecCtx = codecCtx;
    
    LoggerStream(1, @"subtitle codec: '%s' mode: %d enc: %s",
                codecDesc->name,
                codecCtx->sub_charenc_mode,
                codecCtx->sub_charenc);
    
    _subtitleASSEvents = -1;
    
    if (codecCtx->subtitle_header_size) {
                
        NSString *s = [[NSString alloc] initWithBytes:codecCtx->subtitle_header
                                               length:codecCtx->subtitle_header_size
                                             encoding:NSASCIIStringEncoding];
        
        if (s.length) {
            
            NSArray *fields = [KxMovieSubtitleASSParser parseEvents:s];
            if (fields.count && [fields.lastObject isEqualToString:@"Text"]) {
                _subtitleASSEvents = fields.count;
                LoggerStream(2, @"subtitle ass events: %@", [fields componentsJoinedByString:@","]);
            }
        }
    }
    
    return kxMovieErrorNone;
}
-(void) closeFile{
    [self closeAudioStream];
    [self closeVideoStream];
    [self closeSubtitleStream];
    
    _videoStreams = nil;
    _audioStreams = nil;
    _subtitleStreams = nil;
    
    if (_formatCtx) {
        _formatCtx->interrupt_callback.opaque = NULL;
        _formatCtx->interrupt_callback.callback = NULL;
        avformat_close_input(&_formatCtx);
        _formatCtx = NULL;
    }
}

- (void) closeVideoStream{
    _videoStream = -1;
    
    [self closeScaler];
    
    if (_videoFrame) {
        
        av_free(_videoFrame);
        _videoFrame = NULL;
    }
    
    if (_videoCodecCtx) {
        
        avcodec_close(_videoCodecCtx);
        _videoCodecCtx = NULL;
    }
}

- (void) closeAudioStream{
    _audioStream = -1;
        
    if (_swrBuffer) {
        free(_swrBuffer);
        _swrBuffer = NULL;
        _swrBufferSize = 0;
    }
    
    if (_swrContext) {
        
        swr_free(&_swrContext);
        _swrContext = NULL;
    }
        
    if (_audioFrame) {
        
        av_free(_audioFrame);
        _audioFrame = NULL;
    }
    
    if (_audioCodecCtx) {
        
        avcodec_close(_audioCodecCtx);
        _audioCodecCtx = NULL;
    }
}

- (void) closeSubtitleStream
{
    _subtitleStream = -1;
    
    if (_subtitleCodecCtx) {
        
        avcodec_close(_subtitleCodecCtx);
        _subtitleCodecCtx = NULL;
    }
}

- (void) closeScaler
{
    if (_swsContext) {
        sws_freeContext(_swsContext);
        _swsContext = NULL;
    }
    
    if (_pictureValid) {
        avpicture_free(&_picture);
        _pictureValid = NO;
    }
}

- (BOOL) setupScaler
{
    [self closeScaler];
    
    _pictureValid = avpicture_alloc(&_picture,
                                    AV_PIX_FMT_RGB24,
                                    _videoCodecCtx->width,
                                    _videoCodecCtx->height) == 0;
    
	if (!_pictureValid)
        return NO;

	_swsContext = sws_getCachedContext(_swsContext,
                                       _videoCodecCtx->width,
                                       _videoCodecCtx->height,
                                       _videoCodecCtx->pix_fmt,
                                       _videoCodecCtx->width,
                                       _videoCodecCtx->height,
                                       AV_PIX_FMT_RGB24,
                                       SWS_FAST_BILINEAR,
                                       NULL, NULL, NULL);
        
    return _swsContext != NULL;
}

- (KxVideoFrame *) handleVideoFrame
{
    if (!_videoFrame->data[0])
        return nil;
    
    KxVideoFrame *frame;
    
    if (_videoFrameFormat == KxVideoFrameFormatYUV) {
            
        KxVideoFrameYUV * yuvFrame = [[KxVideoFrameYUV alloc] init];
        
        yuvFrame.luma = copyFrameData(_videoFrame->data[0],
                                      _videoFrame->linesize[0],
                                      _videoCodecCtx->width,
                                      _videoCodecCtx->height);
        
        yuvFrame.chromaB = copyFrameData(_videoFrame->data[1],
                                         _videoFrame->linesize[1],
                                         _videoCodecCtx->width / 2,
                                         _videoCodecCtx->height / 2);
        
        yuvFrame.chromaR = copyFrameData(_videoFrame->data[2],
                                         _videoFrame->linesize[2],
                                         _videoCodecCtx->width / 2,
                                         _videoCodecCtx->height / 2);
        
        frame = yuvFrame;
    
    } else {
    
        if (!_swsContext &&
            ![self setupScaler]) {
            
            LoggerVideo(0, @"fail setup video scaler");
            return nil;
        }
        
        sws_scale(_swsContext,
                  (const uint8_t **)_videoFrame->data,
                  _videoFrame->linesize,
                  0,
                  _videoCodecCtx->height,
                  _picture.data,
                  _picture.linesize);
        
        
        KxVideoFrameRGB *rgbFrame = [[KxVideoFrameRGB alloc] init];
        
        rgbFrame.linesize = _picture.linesize[0];
        rgbFrame.rgb = [NSData dataWithBytes:_picture.data[0]
                                    length:rgbFrame.linesize * _videoCodecCtx->height];
        frame = rgbFrame;
    }    
    
    frame.width = _videoCodecCtx->width;
    frame.height = _videoCodecCtx->height;
    frame.position = av_frame_get_best_effort_timestamp(_videoFrame) * _videoTimeBase;
    
    const int64_t frameDuration = av_frame_get_pkt_duration(_videoFrame);
    if (frameDuration) {
        
        frame.duration = frameDuration * _videoTimeBase;
        frame.duration += _videoFrame->repeat_pict * _videoTimeBase * 0.5;
        
        //if (_videoFrame->repeat_pict > 0) {
        //    LoggerVideo(0, @"_videoFrame.repeat_pict %d", _videoFrame->repeat_pict);
        //}
        
    } else {
        
        // sometimes, ffmpeg unable to determine a frame duration
        // as example yuvj420p stream from web camera
        frame.duration = 1.0 / _fps;
    }    
    
#if 0
    LoggerVideo(2, @"VFD: %.4f %.4f | %lld ",
                frame.position,
                frame.duration,
                av_frame_get_pkt_pos(_videoFrame));
#endif
    
    return frame;
}

- (KxAudioFrame *) handleAudioFrame
{
    if (!_audioFrame->data[0])
        return nil;
    
    id<KxAudioManager> audioManager = [KxAudioManager audioManager];
    
    const NSUInteger numChannels = audioManager.numOutputChannels;
    NSInteger numFrames;
    
    void * audioData;
    
    if (_swrContext) {
        
        const NSUInteger ratio = MAX(1, audioManager.samplingRate / _audioCodecCtx->sample_rate) *
                                 MAX(1, audioManager.numOutputChannels / _audioCodecCtx->channels) * 2;
        
        const int bufSize = av_samples_get_buffer_size(NULL,
                                                       audioManager.numOutputChannels,
                                                       _audioFrame->nb_samples * ratio,
                                                       AV_SAMPLE_FMT_S16,
                                                       1);
        
        if (!_swrBuffer || _swrBufferSize < bufSize) {
            _swrBufferSize = bufSize;
            _swrBuffer = realloc(_swrBuffer, _swrBufferSize);
        }
        
        Byte *outbuf[2] = { _swrBuffer, 0 };
        
        numFrames = swr_convert(_swrContext,
                                outbuf,
                                _audioFrame->nb_samples * ratio,
                                (const uint8_t **)_audioFrame->data,
                                _audioFrame->nb_samples);
        
        if (numFrames < 0) {
            LoggerAudio(0, @"fail resample audio");
            return nil;
        }
        
        //int64_t delay = swr_get_delay(_swrContext, audioManager.samplingRate);
        //if (delay > 0)
        //    LoggerAudio(0, @"resample delay %lld", delay);
        
        audioData = _swrBuffer;
        
    } else {
    
        if (_audioCodecCtx->sample_fmt != AV_SAMPLE_FMT_S16) {
            NSAssert(false, @"bucheck, audio format is invalid");
            return nil;
        }
        
        audioData = _audioFrame->data[0];
        numFrames = _audioFrame->nb_samples;
    }
    
    const NSUInteger numElements = numFrames * numChannels;
    NSMutableData *data = [NSMutableData dataWithLength:numElements * sizeof(float)];
    
    float scale = 1.0 / (float)INT16_MAX ;
    vDSP_vflt16((SInt16 *)audioData, 1, data.mutableBytes, 1, numElements);
    vDSP_vsmul(data.mutableBytes, 1, &scale, data.mutableBytes, 1, numElements);
    
    KxAudioFrame *frame = [[KxAudioFrame alloc] init];
    frame.position = av_frame_get_best_effort_timestamp(_audioFrame) * _audioTimeBase;
    frame.duration = av_frame_get_pkt_duration(_audioFrame) * _audioTimeBase;
    frame.samples = data;
    
    if (frame.duration == 0) {
        // sometimes ffmpeg can't determine the duration of audio frame
        // especially of wma/wmv format
        // so in this case must compute duration
        frame.duration = frame.samples.length / (sizeof(float) * numChannels * audioManager.samplingRate);
    }
    
#if 0
    LoggerAudio(2, @"AFD: %.4f %.4f | %.4f ",
                frame.position,
                frame.duration,
                frame.samples.length / (8.0 * 44100.0));
#endif
    
    return frame;
}

- (KxSubtitleFrame *) handleSubtitle: (AVSubtitle *)pSubtitle
{
    NSMutableString *ms = [NSMutableString string];
    
    for (NSUInteger i = 0; i < pSubtitle->num_rects; ++i) {
       
        AVSubtitleRect *rect = pSubtitle->rects[i];
        if (rect) {
            
            if (rect->text) { // rect->type == SUBTITLE_TEXT
                
                NSString *s = [NSString stringWithUTF8String:rect->text];
                if (s.length) [ms appendString:s];
                
            } else if (rect->ass && _subtitleASSEvents != -1) {
                
                NSString *s = [NSString stringWithUTF8String:rect->ass];
                if (s.length) {
                    
                    NSArray *fields = [KxMovieSubtitleASSParser parseDialogue:s numFields:_subtitleASSEvents];
                    if (fields.count && [fields.lastObject length]) {
                        
                        s = [KxMovieSubtitleASSParser removeCommandsFromEventText: fields.lastObject];
                        if (s.length) [ms appendString:s];
                    }                    
                }
            }
        }
    }
    
    if (!ms.length)
        return nil;
    
    KxSubtitleFrame *frame = [[KxSubtitleFrame alloc] init];
    frame.text = [ms copy];   
    frame.position = pSubtitle->pts / AV_TIME_BASE + pSubtitle->start_display_time;
    frame.duration = (CGFloat)(pSubtitle->end_display_time - pSubtitle->start_display_time) / 1000.f;
    
#if 0
    LoggerStream(2, @"SUB: %.4f %.4f | %@",
          frame.position,
          frame.duration,
          frame.text);
#endif
    
    return frame;    
}

- (BOOL) interruptDecoder{
    if (_interruptCallback)
        return _interruptCallback();
    return NO;
}

#pragma mark - public
- (BOOL) setupVideoFrameFormat: (KxVideoFrameFormat) format{
    if (format == KxVideoFrameFormatYUV &&
        _videoCodecCtx &&
        (_videoCodecCtx->pix_fmt == AV_PIX_FMT_YUV420P || _videoCodecCtx->pix_fmt == AV_PIX_FMT_YUVJ420P)) {
        
        _videoFrameFormat = KxVideoFrameFormatYUV;
        return YES;
    }
    
    _videoFrameFormat = KxVideoFrameFormatRGB;
    return _videoFrameFormat == format;
}
- (NSArray *) decodeFrames: (CGFloat) minDuration{
    if (_videoStream == -1 &&
        _audioStream == -1)
        return nil;

    NSMutableArray *result = [NSMutableArray array];
    
    AVPacket packet;
    
    CGFloat decodedDuration = 0;
    
    BOOL finished = NO;
    
    while (!finished) {
        
        if (av_read_frame(_formatCtx, &packet) < 0) {
            _isEOF = YES;
            break;
        }
        
        if (packet.stream_index ==_videoStream) {
           
            int pktSize = packet.size;
            
            while (pktSize > 0) {
                            
                int gotframe = 0;
                int len = avcodec_decode_video2(_videoCodecCtx,
                                                _videoFrame,
                                                &gotframe,
                                                &packet);
                
                if (len < 0) {
                    LoggerVideo(0, @"decode video error, skip packet");
                    break;
                }
                
                if (gotframe) {
                    
                    if (!_disableDeinterlacing &&
                        _videoFrame->interlaced_frame) {
//                        avpicture_deinterlace((AVPicture*)_videoFrame,
//                                              (AVPicture*)_videoFrame,
//                                              _videoCodecCtx->pix_fmt,
//                                              _videoCodecCtx->width,
//                                              _videoCodecCtx->height);
                    }
                    
                    KxVideoFrame *frame = [self handleVideoFrame];
                    if (frame) {
                        
                        [result addObject:frame];
                        
                        _position = frame.position;
                        decodedDuration += frame.duration;
                        if (decodedDuration > minDuration)
                            finished = YES;
                    }
                }
                                
                if (0 == len)
                    break;
                
                pktSize -= len;
            }
            
        } else if (packet.stream_index == _audioStream) {
                        
            int pktSize = packet.size;
            
            while (pktSize > 0) {
                
                int gotframe = 0;
                int len = avcodec_decode_audio4(_audioCodecCtx,
                                                _audioFrame,                                                
                                                &gotframe,
                                                &packet);
                
                if (len < 0) {
                    LoggerAudio(0, @"decode audio error, skip packet");
                    break;
                }
                
                if (gotframe) {
                    
                    KxAudioFrame * frame = [self handleAudioFrame];
                    if (frame) {
                        
                        [result addObject:frame];
                                                
                        if (_videoStream == -1) {
                            
                            _position = frame.position;
                            decodedDuration += frame.duration;
                            if (decodedDuration > minDuration)
                                finished = YES;
                        }
                    }
                }
                
                if (0 == len)
                    break;
                
                pktSize -= len;
            }
            
        } else if (packet.stream_index == _artworkStream) {
            
            if (packet.size) {

                KxArtworkFrame *frame = [[KxArtworkFrame alloc] init];
                frame.picture = [NSData dataWithBytes:packet.data length:packet.size];
                [result addObject:frame];
            }
            
        } else if (packet.stream_index == _subtitleStream) {
            
            int pktSize = packet.size;
            
            while (pktSize > 0) {
                
                AVSubtitle subtitle;
                int gotsubtitle = 0;
                int len = avcodec_decode_subtitle2(_subtitleCodecCtx,
                                                  &subtitle,
                                                  &gotsubtitle,
                                                  &packet);
                
                if (len < 0) {
                    LoggerStream(0, @"decode subtitle error, skip packet");
                    break;
                }
                
                if (gotsubtitle) {
                    
                    KxSubtitleFrame *frame = [self handleSubtitle: &subtitle];
                    if (frame) {
                        [result addObject:frame];
                    }
                    avsubtitle_free(&subtitle);
                }
                
                if (0 == len)
                    break;
                
                pktSize -= len;
            }
        }
        av_packet_unref(&packet);
	}
    return result;
}
#pragma mark - dynamic property
- (CGFloat) duration{
    if (!_formatCtx)
        return 0;
    if (_formatCtx->duration == AV_NOPTS_VALUE)
        return MAXFLOAT;
    return (CGFloat)_formatCtx->duration / AV_TIME_BASE;
}
- (CGFloat) position{
    return _position;
}
- (void) setPosition: (CGFloat)seconds{
    _position = seconds;
    _isEOF = NO;
    
    if (_videoStream != -1) {
        int64_t ts = (int64_t)(seconds / _videoTimeBase);
        avformat_seek_file(_formatCtx, _videoStream, ts, ts, ts, AVSEEK_FLAG_FRAME);
        avcodec_flush_buffers(_videoCodecCtx);
    }
    
    if (_audioStream != -1) {
        int64_t ts = (int64_t)(seconds / _audioTimeBase);
        avformat_seek_file(_formatCtx, _audioStream, ts, ts, ts, AVSEEK_FLAG_FRAME);
        avcodec_flush_buffers(_audioCodecCtx);
    }
}
- (NSUInteger) frameWidth{
    return _videoCodecCtx ? _videoCodecCtx->width : 0;
}
- (NSUInteger) frameHeight{
    return _videoCodecCtx ? _videoCodecCtx->height : 0;
}
- (CGFloat) sampleRate{
    return _audioCodecCtx ? _audioCodecCtx->sample_rate : 0;
}
- (NSUInteger) audioStreamsCount{
    return [_audioStreams count];
}
- (NSUInteger) subtitleStreamsCount{
    return [_subtitleStreams count];
}
- (NSInteger) selectedAudioStream{
    if (_audioStream == -1)
        return -1;
    NSNumber *n = [NSNumber numberWithInteger:_audioStream];
    return [_audioStreams indexOfObject:n];
}
- (void) setSelectedAudioStream:(NSInteger)selectedAudioStream{
    NSInteger audioStream = [_audioStreams[selectedAudioStream] integerValue];
    [self closeAudioStream];
    kxMovieError errCode = [self openAudioStream: audioStream];
    if (kxMovieErrorNone != errCode) {
        LoggerAudio(0, @"%@", errorMessage(errCode));
    }
}

- (NSInteger) selectedSubtitleStream
{
    if (_subtitleStream == -1)
        return -1;
    return [_subtitleStreams indexOfObject:@(_subtitleStream)];
}
- (void) setSelectedSubtitleStream:(NSInteger)selected{
    [self closeSubtitleStream];
    
    if (selected == -1) {
        
        _subtitleStream = -1;
        
    } else {
        
        NSInteger subtitleStream = [_subtitleStreams[selected] integerValue];
        kxMovieError errCode = [self openSubtitleStream:subtitleStream];
        if (kxMovieErrorNone != errCode) {
            LoggerStream(0, @"%@", errorMessage(errCode));
        }
    }
}
- (BOOL) validAudio{
    return _audioStream != -1;
}
- (BOOL) validVideo{
    return _videoStream != -1;
}
- (BOOL) validSubtitles{
    return _subtitleStream != -1;
}
- (NSDictionary *) info{
    if (!_info) {
        
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        
        if (_formatCtx) {
            
            const char *formatName = _formatCtx->iformat->name;
            [md setValue: [NSString stringWithCString:formatName encoding:NSUTF8StringEncoding]
                  forKey: @"format"];
            
            if (_formatCtx->bit_rate) {
                
                [md setValue: [NSNumber numberWithInt:_formatCtx->bit_rate]
                      forKey: @"bitrate"];
            }
            
            if (_formatCtx->metadata) {
                
                NSMutableDictionary *md1 = [NSMutableDictionary dictionary];
                
                AVDictionaryEntry *tag = NULL;
                while((tag = av_dict_get(_formatCtx->metadata, "", tag, AV_DICT_IGNORE_SUFFIX))) {
                    
                    [md1 setValue: [NSString stringWithCString:tag->value encoding:NSUTF8StringEncoding]
                           forKey: [NSString stringWithCString:tag->key encoding:NSUTF8StringEncoding]];
                }
                
                [md setValue: [md1 copy] forKey: @"metadata"];
            }
            
            char buf[256];
            
            if (_videoStreams.count) {
                NSMutableArray *ma = [NSMutableArray array];
                for (NSNumber *n in _videoStreams) {
                    AVStream *st = _formatCtx->streams[n.integerValue];
                    avcodec_string(buf, sizeof(buf), st->codec, 1);
                    NSString *s = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                    if ([s hasPrefix:@"Video: "])
                        s = [s substringFromIndex:@"Video: ".length];
                    [ma addObject:s];
                }
                md[@"video"] = ma.copy;
            }
            
            if (_audioStreams.count) {
                NSMutableArray *ma = [NSMutableArray array];
                for (NSNumber *n in _audioStreams) {
                    AVStream *st = _formatCtx->streams[n.integerValue];
                    
                    NSMutableString *ms = [NSMutableString string];
                    AVDictionaryEntry *lang = av_dict_get(st->metadata, "language", NULL, 0);
                    if (lang && lang->value) {
                        [ms appendFormat:@"%s ", lang->value];
                    }
                    
                    avcodec_string(buf, sizeof(buf), st->codec, 1);
                    NSString *s = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                    if ([s hasPrefix:@"Audio: "])
                        s = [s substringFromIndex:@"Audio: ".length];
                    [ms appendString:s];
                    
                    [ma addObject:ms.copy];
                }
                md[@"audio"] = ma.copy;
            }
            
            if (_subtitleStreams.count) {
                NSMutableArray *ma = [NSMutableArray array];
                for (NSNumber *n in _subtitleStreams) {
                    AVStream *st = _formatCtx->streams[n.integerValue];
                    
                    NSMutableString *ms = [NSMutableString string];
                    AVDictionaryEntry *lang = av_dict_get(st->metadata, "language", NULL, 0);
                    if (lang && lang->value) {
                        [ms appendFormat:@"%s ", lang->value];
                    }
                    
                    avcodec_string(buf, sizeof(buf), st->codec, 1);
                    NSString *s = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                    if ([s hasPrefix:@"Subtitle: "])
                        s = [s substringFromIndex:@"Subtitle: ".length];
                    [ms appendString:s];
                    
                    [ma addObject:ms.copy];
                }
                md[@"subtitles"] = ma.copy;
            }
            
        }
        
        _info = [md copy];
    }
    return _info;
}
- (NSString *) videoStreamFormatName{
    if (!_videoCodecCtx)
        return nil;
    
    if (_videoCodecCtx->pix_fmt == AV_PIX_FMT_NONE)
        return @"";
    
    const char *name = av_get_pix_fmt_name(_videoCodecCtx->pix_fmt);
    return name ? [NSString stringWithCString:name encoding:NSUTF8StringEncoding] : @"?";
}
- (CGFloat) startTime{
    if (_videoStream != -1) {
        
        AVStream *st = _formatCtx->streams[_videoStream];
        if (AV_NOPTS_VALUE != st->start_time)
            return st->start_time * _videoTimeBase;
        return 0;
    }
    
    if (_audioStream != -1) {
        
        AVStream *st = _formatCtx->streams[_audioStream];
        if (AV_NOPTS_VALUE != st->start_time)
            return st->start_time * _audioTimeBase;
        return 0;
    }
    
    return 0;
}
#pragma mark - dealloc
- (void) dealloc{
    LoggerStream(2, @"%@ dealloc", self);
    [self closeFile];
}
@end

static int interrupt_callback(void *ctx){
    if (!ctx)
        return 0;
    __unsafe_unretained KxMovieDecoder *p = (__bridge KxMovieDecoder *)ctx;
    const BOOL r = [p interruptDecoder];
    if (r) LoggerStream(1, @"DEBUG: INTERRUPT_CALLBACK!");
    return r;
}
