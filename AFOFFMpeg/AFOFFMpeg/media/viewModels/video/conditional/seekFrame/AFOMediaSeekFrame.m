//
//  AFOMediaSeekFrame.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AFOMediaSeekFrame.h"
#import "AFOMediaThumbnail.h"
#import "AFOMediaConditional.h"
@interface AFOMediaSeekFrame (){
    AVCodec             *avcodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVFrame             *avFrame;
    AVStream            *avStream;
}
@property (nonatomic, assign)  NSInteger              videoStream;
@property (nonatomic, assign)  int                    zoomFacto;
@property (nonatomic, assign)  int                    outWidth;
@property (nonatomic, assign)  int                    outHeight;
@property (nonatomic, strong)  AFOMediaConditional   *conditonal;
@end
@implementation AFOMediaSeekFrame
#pragma mark ------------ initialize
+ (void)initialize{
    if (self == [AFOMediaSeekFrame class]) {
        ///------ 注册解码器
        avcodec_register_all();
        av_register_all();
        avformat_network_init();
    }
}
#pragma mark ------------ custom
+ (instancetype)vedioName:(NSString *)name
                     path:(NSString *)path
                imagePath:(NSString *)imagePath
                    plist:(NSString *)plist
                    block:(mediaSeekFrameDetailBlock)block{
    AFOMediaSeekFrame *seekFrame = NULL;
    if (name != NULL || name != nil){
        AFOMediaSeekFrame *temp = [[AFOMediaSeekFrame alloc] init];
        [temp avInitialize:path name:name imagePath:imagePath plist:plist block:^(BOOL isWrite,
                                                                                  BOOL isCutting,
                                                                                  
                                                        NSString *createTime,
                                                                                  NSString *vedioName,
                                                                                  NSString *imageName,
                                                                                  int width,
                                                                                  int height) {
            block(isWrite, isCutting, createTime, vedioName, imageName, width, height);
        }];
        seekFrame = temp;
    }
    return seekFrame;
}
#pragma mark ------ 初始化
- (void)avInitialize:(NSString *)path
                name:(NSString *)name
           imagePath:(NSString *)imagePath
               plist:(NSString *)plist
               block:(mediaSeekFrameDetailBlock)block
            {
    _videoStream = -1;
    avFormatContext = avformat_alloc_context();
   __block NSError *avError = NULL;
    WeakObject(self);
    [AFOMediaConditional mediaSesourcesConditionalPath:[AFOMediaThumbnail vedioAddress:path name:name] block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex) {
        StrongObject(self);
        avError = error;
        self.videoStream = videoIndex;
    }];
    if (avError.code != 0) {
        return;
    }
    ///------
    avformat_open_input(&avFormatContext, [[AFOMediaThumbnail vedioAddress:path name:name] UTF8String], NULL, NULL);
    avformat_find_stream_info(avFormatContext, NULL);
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avcodec = avcodec_find_decoder(avCodecContext -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContext, avcodec, NULL);
    ///------ 获取视频流编解码上下文指针
    avStream = avFormatContext -> streams[self.videoStream];
    ///------ 正常流程，分配视频帧
    avFrame = av_frame_alloc();
    ///------
    [self YUVConversionJPG:[AFOMediaThumbnail vedioAddress:path name:name] name:name imagePath:imagePath plist:plist block:^(BOOL isWrite,
                                                                                                                                         BOOL isCutting) {
        block(isWrite, isCutting, [self createTime], name, [AFOMediaThumbnail imageName:name], self.outWidth, self.outHeight);
    }];
}
#pragma mark ------ YUV生成jPG
- (void)YUVConversionJPG:(NSString *)path
                    name:(NSString *)name
               imagePath:(NSString *)imagePath
                   plist:(NSString *)plist
                   block:(mediaSeekFrameBlock)block{
    struct SwsContext *context = sws_getContext(avCodecContext -> width,
                                                avCodecContext -> height,
                                                AV_PIX_FMT_YUV420P,
                                                self.outWidth,
                                                self.outHeight ,
                                                AV_PIX_FMT_RGB24,
                                                SWS_FAST_BILINEAR,
                                                NULL,
                                                NULL,
                                                NULL);
    ///
    AVFrame *avFrameYUV = av_frame_alloc();
    /// Determine required buffer size and allocate buffer.
    int numBytes = av_image_get_buffer_size(AV_PIX_FMT_RGB24, self.outWidth, self.outWidth, 1);
    uint8_t *buffer = (uint8_t *) av_malloc(numBytes * sizeof(uint8_t));
    ///
    av_image_fill_arrays(avFrameYUV->data, avFrameYUV->linesize, buffer, AV_PIX_FMT_RGB24, self.outWidth, self.outHeight, 1);
    ///
        int i = 0;
        AVPacket packet;
        while (av_read_frame(avFormatContext, &packet) >= 0) {
            if (packet.stream_index != self.videoStream) {
                continue;
            }
            avcodec_send_packet(avCodecContext, &packet);
            if (avcodec_receive_frame(avCodecContext, avFrame) != 0) {
                continue;
            }
            sws_scale(context, (uint8_t const * const *) avFrame->data, avFrame->linesize, 0, avFrame->height, avFrameYUV->data, avFrameYUV->linesize);
            // Save the frame to disk.
            if (++i <= 1) {
                [self saveImageFrame:avFrameYUV path:path width:self.outWidth height:self.outHeight imagePath:[AFOMediaThumbnail imageNameFromPath:imagePath name:name] block:^(BOOL isWrite,
                                                                                                                                                                                                      BOOL isCutting) {
                    block(isWrite, isCutting);
                }];
            }else{
                break;
            }
            av_packet_unref(&packet);
        }
        //free
        av_free(avFrameYUV);
        av_free(buffer);
        sws_freeContext(context);
        [self freeResources];
}
#pragma mark ------
- (void)saveImageFrame:(AVFrame *)aframe
                  path:(NSString *)path
                 width:(int)width
                height:(int)height
             imagePath:(NSString *)imagePath
                 block:(mediaSeekFrameBlock)block{

    FILE *pFile = NULL;
    // Open file.
    pFile = fopen([imagePath UTF8String], "wb");
    if (pFile == NULL) {
        return;
    }
    // Write header.
    fprintf(pFile, "P6\n%d %d\n255\n", width, height);
    // Write pixel data.
    size_t size = 0;
    for (int y = 0; y < height; y++) {
       size = fwrite(aframe->data[0]+y*aframe->linesize[0], 1, width*3, pFile);
    }
    if (size > 0) {
        block(YES, YES);
    }else{
        block(NO, NO);
    }
    // Close file.
    fclose(pFile);
}
#pragma mark ------------ free
- (void)freeResources{
    ///------
    av_free(avFrame);
    ///------
    av_free(avStream);
    //------ 关闭解码器
    if (avCodecContext){
        avcodec_close(avCodecContext);
    };
//    //------ 关闭文件
//    if (avFormatContext){
//        avformat_close_input(&avFormatContext);
//    };
    ///------
    avcodec_free_context(&avCodecContext);
    avCodecContext = NULL;
    ///------
    avcodec = NULL;
}
#pragma mark ------------ property
#pragma mark ------ zoomFacto
- (int)zoomFacto{
    _zoomFacto = 2;
    return _zoomFacto;
}
#pragma mark ------ outWidth
- (int)outWidth{
    _outWidth = avCodecContext->width / self.zoomFacto;
    return _outWidth;
}
#pragma mark ------ outHeight
- (int)outHeight{
    _outHeight = avCodecContext->height / self.zoomFacto;
    return _outHeight;
}
#pragma mark ------
- (NSString *)createTime{
    AVDictionaryEntry *entry = NULL;
    entry = av_dict_get(avFormatContext -> metadata, "creation_time", NULL, AV_DICT_IGNORE_SUFFIX);
    if (!entry) {
        return @"0";
    }
    return [NSString stringWithUTF8String:entry -> value];
}
#pragma mark ------ 
- (AFOMediaConditional *)conditonal{
    if (!_conditonal) {
        _conditonal = [[AFOMediaConditional alloc] init];
    }
    return _conditonal;
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"dealloc AFOMediaSeekFrame");
}
@end
