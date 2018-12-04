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
    AVFormatContext   *avFormatContext = NULL;
    AVCodecContext    *avCodecContext  = NULL;
    AVCodec           *avCodec         = NULL;
    int videoStream = -1;
    int audioStream = -1;
    
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
    ///------ Find the first audio stream.
    audioStream = av_find_best_stream(avFormatContext,
                                      AVMEDIA_TYPE_AUDIO,
                                      -1,
                                      -1,
                                      NULL,
                                      0);
    if (audioStream == -1) {
        return;
    }
    ///------ Find the first video stream.
    videoStream = av_find_best_stream(avFormatContext,
                                      AVMEDIA_TYPE_VIDEO,
                                      -1,
                                      -1,
                                      NULL,
                                      0);
    //------ Didn't find a video stream.
    if (videoStream == -1) {
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeAllocateCodecContextFailure],0,0);
        return ;
    }
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodec = avcodec_find_decoder(avCodecContext -> codec_id);
    if(avCodec == NULL){
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeNoneDecoderFailure],0,0);
        return;
    }
    ///------ Open codec
    if(avcodec_open2(avCodecContext, avCodec, NULL) < 0){
        block([AFOMediaErrorCodeManager errorCode:AFOPlayMediaErrorCodeOpenDecoderFailure],0,0);
        return;
    }
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
#pragma mark ------
- (void)dealloc{
    NSLog(@"dealloc AFOMediaConditional");
}
@end
