//
//  AFOMediaSeekFrame.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//
#import "AFOMediaSeekFrame.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOMediaSeekFrame+Conditional.h"
#import "AFOMediaThumbnail.h"
#import "AFOMediaConditional.h"
#import "AFOMediaYUV.h"
@interface AFOMediaSeekFrame (){
    AVCodec             *avcodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVFrame             *avFrame;
}
@property (nonatomic, assign)  NSInteger              videoStream;
@property (nonatomic, assign)  int                    zoomFacto;
@property (nonatomic, assign)  int                    outWidth;
@property (nonatomic, assign)  int                    outHeight;
@property (nonatomic, strong)  AFOMediaConditional   *conditonal;
@property (nonnull, nonatomic, strong) AFOMediaYUV   *meidaYUV;
@end
@implementation AFOMediaSeekFrame
#pragma mark ------------ init
- (instancetype)init{
    if (self = [super init]) {
        av_register_all();
        ///---
        _videoStream = -1;
        avFormatContext = avformat_alloc_context();
        avCodecContext = avcodec_alloc_context3(NULL);
    }
    return self;
}
#pragma mark ------------ 
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
               block:(mediaSeekFrameDetailBlock)block{
    __block NSError *verror;
    WeakObject(self);
    [AFOMediaConditional mediaSesourcesConditionalPath:[AFOMediaSeekFrame vedioAddress:path name:name] block:^(NSError *error, NSInteger videoIndex, NSInteger audioIndex) {
        StrongObject(self);
        self.videoStream = videoIndex;
        verror = error;
    }];
    if (verror.code != 0) {
        return;
    }
    ///------ Open video file.
    if(avformat_open_input(&avFormatContext, [[AFOMediaSeekFrame vedioAddress:path name:name] UTF8String], NULL, NULL) != 0){
        return;
    }
    ///------ Retrieve stream information.
    if (avformat_find_stream_info(avFormatContext, NULL) < 0) {
        return;
    }
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avcodec = avcodec_find_decoder(avCodecContext -> codec_id);
    ///------ Open codec
    avcodec_open2(avCodecContext, avcodec, NULL);
    ///------ 正常流程，分配视频帧
    avFrame = av_frame_alloc();
    ///------
    [self firstFrameToCover:[AFOMediaThumbnail vedioAddress:path name:name] name:name imagePath:imagePath block:^(BOOL isWrite, BOOL isCutting){
            block(isWrite, isCutting, [self createTime], name, [AFOMediaThumbnail imageName:name], self.outWidth, self.outHeight);
        }];
}
#pragma mark ------ 将第一帧作为封面
- (void)firstFrameToCover:(NSString *)path
                     name:(NSString *)name
                imagePath:(NSString *)imagePath
                    block:(mediaSeekFrameBlock)block{
    AVPacket packet;
    while (av_read_frame(avFormatContext, &packet) >= 0) {
        if (packet.stream_index == self.videoStream) {
            if (avcodec_send_packet(avCodecContext, &packet) != 0) {
                continue;
            }
            if (avcodec_receive_frame(avCodecContext, avFrame) != 0) {
                continue;
            }
            if (avFrame ->key_frame == 1) {
                [AFOMediaYUV makeYUVToRGB:avFrame width:avFrame->width height:avFrame->height scale:1.0 block:^(UIImage * _Nonnull image) {
                    NSString *strPath = [NSString stringWithFormat:@"%@/%@",imagePath,[AFOMediaThumbnail imageName:name]];
                    BOOL result = [UIImagePNGRepresentation(image) writeToFile:strPath atomically:YES];
                    block(result,result);
                }];
                break;
            }
            av_packet_unref(&packet);
        }
    }
}
#pragma mark ------------ free
- (void)freeResources{
    ///------
    if (avFrame) {
        av_frame_free(&avFrame);
    }
    //------ 关闭解码器
    if (avCodecContext){
        avcodec_close(avCodecContext);
    };
    //------ 关闭文件
    if (avFormatContext) {
        avformat_close_input(&(avFormatContext));
        avFormatContext = NULL;
    }
    ///------
    avcodec_free_context(&avCodecContext);
    avCodecContext = NULL;
    ///------
    avcodec = NULL;
}
#pragma mark ------------ property
- (AFOMediaYUV *)meidaYUV{
    if (!_meidaYUV) {
        _meidaYUV = [[AFOMediaYUV alloc] init];
    }
    return _meidaYUV;
}
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
    [self freeResources];
    NSLog(@"AFOMediaSeekFrame dealloc");
}
@end
