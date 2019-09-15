//
//  AFOMediaConditional.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//
#import "AFOMediaConditional.h"
@implementation AFOMediaConditional
#pragma mark ------------ 
+ (void)mediaSesourcesConditionalPath:(NSString *)path
                            block:(MediaConditionalBlock) block{
    AVFormatContext   *avFormatContext;
    AVCodecContext    *avCodecContext;
    AVCodec           *avCodec;
   __block NSInteger videoStream = -1;
   __block NSInteger audioStream = -1;
    avFormatContext = avformat_alloc_context();
    ///------ Open video file.
    if(avformat_open_input(&avFormatContext, [path UTF8String], NULL, NULL) != 0){
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeReadFailure],0,0);
        return;
    }
    ///------ Retrieve stream information.
    if (avformat_find_stream_info(avFormatContext, NULL) < 0) {
        // Couldn't find stream information.
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeRetrieveStreamInformationFailure],0,0);
        return;
    }
    ///------ Dump information about file onto standard error.
#if DEBUG
    av_dump_format(avFormatContext, 0, [path UTF8String], 0);
#endif
    ///------
    [self audioVideoStreamFormat:avFormatContext block:^(NSInteger video, NSInteger audio) {
        if (video == -1 && audio == -1){
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeAllocateCodecContextFailure],0,0);
            return ;
        }
        videoStream = video;
        audioStream = audio;
    }];
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    ///------
    [self avCodecDecoder:avCodecContext format:avFormatContext videoIndex:videoStream audioIndex:audioStream block:^(BOOL isTrue, BOOL isOpen) {
        if (!isTrue && isOpen) {
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeAllocateCodecContextFailure],videoStream,audioStream);
            return;
        }
        if (isTrue && !isOpen) {
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeOpenDecoderFailure],videoStream,audioStream);
            return;
        }
    }];
    ///------- return ture
    block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone],videoStream,audioStream);
    //------ 关闭解码器
    if (avCodecContext){
        avcodec_close(avCodecContext);
    };
    avCodecContext = NULL;
    //------ 关闭文件
    if (avFormatContext){
        avformat_close_input(&avFormatContext);
    };
    avFormatContext = NULL;
    ///------
    avcodec_free_context(&avCodecContext);
    avCodecContext = NULL;
    ///------
    avCodec = NULL;
}
#pragma mark ------ first video or audio Fault tolerance
+ (NSInteger)audioVideoStream:(enum AVMediaType)type
                       format:(AVFormatContext *)avFormatContext{
    NSInteger result = av_find_best_stream(avFormatContext,
                                            type,
                                            -1,
                                            -1,
                                            NULL,
                                            0);
    return result;
}
+ (void)audioVideoStreamFormat:(AVFormatContext *)avFormatContext
                        block:(void(^)(NSInteger video, NSInteger audio))block{
    NSInteger resultV = [self audioVideoStream:AVMEDIA_TYPE_VIDEO format:avFormatContext];
    NSInteger resultA = [self audioVideoStream:AVMEDIA_TYPE_AUDIO format:avFormatContext];
    block(resultV,resultA);
}
#pragma mark ------ codec context Fault tolerance
+ (AVCodec *)avCodec:(AVCodecContext *)avCodecContext
               format:(AVFormatContext *)avFormatContext
                index:(NSInteger)index{
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[index] -> codecpar);
    return avcodec_find_decoder(avCodecContext -> codec_id);
}
+ (void)avCodecDecoder:(AVCodecContext *)avCodecContext
                format:(AVFormatContext *)avFormatContext
            videoIndex:(NSInteger)video
            audioIndex:(NSInteger)audio
                 block:(void (^)(BOOL isTrue, BOOL isOpen))block{
    AVCodec *avCodecV = NULL;
    AVCodec *avCodecAu = NULL;
    if (video != -1 && audio == -1) {
        avCodecV = [self avCodec:avCodecContext format:avFormatContext index:video];
        if (avCodecV == NULL) {
            block(NO,YES);
        }
        ///------ Open codec
        if(avcodec_open2(avCodecContext, avCodecV, NULL) < 0){
            block(YES,NO);
        }
    }else if(video == -1 && audio != -1){
        avCodecAu = [self avCodec:avCodecContext format:avFormatContext index:audio];
        if (avCodecV == NULL) {
            block(NO,YES);
        }
        ///------ Open codec
        if(avcodec_open2(avCodecContext, avCodecV, NULL) < 0){
            block(YES,NO);
        }
    }else if(video != -1 && audio != -1){
        ///---
        AVCodecContext *avCodecContextV = avcodec_alloc_context3(NULL);
        avCodecV = [self avCodec:avCodecContextV format:avFormatContext index:video];
        ///---
        AVCodecContext *avCodecContextAu= avcodec_alloc_context3(NULL);
        avCodecAu = [self avCodec:avCodecContextAu format:avFormatContext index:audio];
        ///---
        if (avCodecV == NULL && avCodecAu == NULL) {
            block(NO,YES);
        }
        ///------ Open codec
        if(avcodec_open2(avCodecContextV, avCodecV, NULL) < 0 && avcodec_open2(avCodecContextAu, avCodecAu, NULL) < 0){
            block(YES,NO);
        }
    }
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOMediaConditional dealloc");
}
@end
