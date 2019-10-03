//
//  AFONewMediaManager.m
//  AFOFFMpeg
//
//  Created by xianxueguang on 2019/10/3.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFONewMediaManager.h"

@interface AFONewMediaManager (){
    AVCodec             *avCodec;
    AVFormatContext     *avFormat;
    AVCodecContext      *avCodecContext;
}
@end


@implementation AFONewMediaManager
#pragma mark ------ add method
- (void)registerAudioBaseMethod:(NSString *)path{
    ///------
    avFormat = avformat_alloc_context();
    avformat_open_input(&avFormat, [path UTF8String], NULL, NULL);
    ///------------ audio
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormat -> streams[self.audioStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodec = avcodec_find_decoder(avCodecContext -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContext, avCodec, NULL);
}
- (void)playAudio{
    ///------ play audio
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.audioManager audioFormatContext:self->avFormat codecContext:self->avCodecContext index:self.audioStream];
        [self playAudio];
    });
}
@end
