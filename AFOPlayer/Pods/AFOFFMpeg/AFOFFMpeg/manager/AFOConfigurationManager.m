//
//  AFOConfigurationManager.m
//  AFOFFMpeg
//
//  Created by xianxueguang on 2019/10/4.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOConfigurationManager.h"
#import "AFOMediaConditional.h"
@interface AFOConfigurationManager ()
@end
@implementation AFOConfigurationManager
+ (void)configurationStreamPath:(NSString *)strPath
                          block:(void(^)(NSError *error,
                                         NSInteger videoIndex,
                                         NSInteger audioIndex))block{
    [AFOMediaConditional mediaSesourcesConditionalPath:strPath block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex){
        if (error.code == 0) {
            block(error,videoIndex, audioIndex);
        }else{
            block(error,0, 0);
            return;
        }
    }];
}
+ (void)configurationForPath:(NSString *)strPath
                      stream:(NSInteger)stream
                        block:(void(^)(
                                       AVCodec *codec,
                                       AVFormatContext *format, AVCodecContext *context,
                                       NSInteger videoStream,
                                      NSInteger audioStream))block{
    [AFOMediaConditional mediaSesourcesConditionalPath:strPath block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex){
        if (error.code == 0) {
            ///------------ video
           AVFormatContext *avFormatContext = avformat_alloc_context();
            avformat_open_input(&avFormatContext, [strPath UTF8String], NULL, NULL);
            AVCodecContext *avCodecContext = avcodec_alloc_context3(NULL);
            avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[stream] -> codecpar);
            ///------ Find the decoder for the video stream.
            AVCodec *avCodec = avcodec_find_decoder(avCodecContext -> codec_id);
            ///------ Open codec
            avcodec_open2(avCodecContext, avCodec, NULL);
            block(avCodec,avFormatContext,avCodecContext,videoIndex,audioIndex);
        }else{
            return;
        }
    }];
}
@end
