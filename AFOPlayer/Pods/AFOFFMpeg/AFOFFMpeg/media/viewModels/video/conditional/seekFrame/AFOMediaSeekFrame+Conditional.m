//
//  AFOMediaSeekFrame+Conditional.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/18.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaSeekFrame+Conditional.h"

@implementation AFOMediaSeekFrame (Conditional)
+ (void)mediaSesourcesConditionalPath:(NSString *)path
                        formatContext:(AVFormatContext *)avFormatContext
                         codecContext:(AVCodecContext *)avCodecContext
                                block:(MediaSeekFrameBlock) block{
    __block NSInteger videoStream = -1;
    ///------ Open video file.
    if(avformat_open_input(&avFormatContext, [path UTF8String], NULL, NULL) != 0){
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeReadFailure],0, avFormatContext);
        return;
    }
    ///------ Retrieve stream information.
    if (avformat_find_stream_info(avFormatContext, NULL) < 0) {
        // Couldn't find stream information.
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeRetrieveStreamInformationFailure],0,avFormatContext);
        return;
    }
    ///------ Dump information about file onto standard error.
#if DEBUG
    av_dump_format(avFormatContext, 0, [path UTF8String], 0);
#endif
    ///------
    [self audioVideoStreamFormat:avFormatContext block:^(NSInteger video) {
        if (video == -1){
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeAllocateCodecContextFailure],0, avFormatContext);
            return ;
        }
        videoStream = video;
    }];
    ///------
    [self avCodecDecoder:avCodecContext format:avFormatContext videoIndex:videoStream block:^(BOOL isTrue, BOOL isOpen) {
        if (!isTrue && isOpen) {
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeAllocateCodecContextFailure],videoStream, avFormatContext);
            return;
        }
        if (isTrue && !isOpen) {
            block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeOpenDecoderFailure],videoStream, avFormatContext);
            return;
        }
    }];
    block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorNone],videoStream,avFormatContext);
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
                         block:(void(^)(NSInteger video))block{
    NSInteger resultV = [self audioVideoStream:AVMEDIA_TYPE_VIDEO format:avFormatContext];
    block(resultV);
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
                 block:(void (^)(BOOL isTrue, BOOL isOpen))block{
    AVCodec *avCodecV = NULL;
    if (video != -1) {
        avCodecV = [self avCodec:avCodecContext format:avFormatContext index:video];
        if (avCodecV == NULL) {
            block(NO,YES);
        }
        ///------ Open codec
        if(avcodec_open2(avCodecContext, avCodecV, NULL) < 0){
            block(YES,NO);
        }
    }
}
+ (NSString *)vedioAddress:(NSString *)path
                      name:(NSString *)name{
    NSString *string = [NSString stringWithFormat:@"%@/%@",path,name];
    return string;
}
@end
