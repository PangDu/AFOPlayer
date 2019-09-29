//
//  AFOMediaManager.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/1.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaDecoder.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOMediaManager.h"
@interface AFOMediaDecoder (){
    AVCodec             *avCodec;
    AVFormatContext     *avFormatContext;
    AVCodecContext      *avCodecContext;
    AVStream            *avStream;
    AVFrame             *avFrame;
    AVPacket            packet;
}
@property (nonatomic, assign) NSInteger         videoStream;
@property (nonatomic, assign) NSInteger         audioStream;
@property (nonatomic, assign) NSInteger         vedioWidth;
@property (nonatomic, assign) NSInteger         vedioHeight;
@property (nonatomic, strong) dispatch_queue_t  queue_t;
@property (nonatomic, strong) AFOMediaManager   *mediaManager;
@property (nonatomic, assign) BOOL      isFree;
@end
@implementation AFOMediaDecoder
+ (void)initialize{
    if (self == [AFOMediaDecoder class]) {
        av_register_all();
        avformat_network_init();
    }
}
- (instancetype)init{
    if (self = [super init]) {
        _videoStream = -1;
        _isFree = NO;
    }
    return self;
}
- (void)abnormalConditionPath:(NSString *)strPath{
    ///------ Open video file.
    if(avformat_open_input(&avFormatContext, [strPath UTF8String], NULL, NULL) != 0){
        return;
    }
    ///------ Retrieve stream information.
    if (avformat_find_stream_info(avFormatContext, NULL) < 0) {
        avformat_close_input(&avFormatContext);
        // Couldn't find stream information.
        return;
    }
    ///------ Dump information about file onto standard error.
#if DEBUG
    av_dump_format(avFormatContext, 0, [strPath UTF8String], 0);
#endif
    ///------ Find the first video stream.
    for (int i = 0; i < avFormatContext -> nb_streams; i++) {
        if (avFormatContext ->streams[i] -> codecpar -> codec_type == AVMEDIA_TYPE_VIDEO) {
            self.videoStream = i;
            break;
        }
    }
    //------ Didn't find a video stream.
    if (self.videoStream == -1) {
        return ;
    }
    ///------ Get a pointer to the codec context for the video stream.
    avCodecContext = avcodec_alloc_context3(NULL);
    avcodec_parameters_to_context(avCodecContext, avFormatContext -> streams[self.videoStream] -> codecpar);
    ///------ Find the decoder for the video stream.
    avCodec = avcodec_find_decoder(avCodecContext -> codec_id);
    if(avCodec == NULL){
        return;
    }
    ///------ Open codec
    if(avcodec_open2(avCodecContext, avCodec, NULL) < 0){
        return;
    }
    ///------- return ture
    self.vedioWidth = avCodecContext -> width;
    self.vedioHeight = avCodecContext -> height;
    ///------ 获取视频流编解码上下文指针
    avStream = avFormatContext -> streams[self.videoStream];
    ///------ 正常流程，分配视频帧
    avFrame = av_frame_alloc();
}
#pragma mark ------ 显示
- (void)displayVedioPath:(NSString *)strPath
                   block:(mediaManagerBlock)block{
    [self abnormalConditionPath:strPath];
    WeakObject(self);
    dispatch_async(self.queue_t, ^{
        StrongObject(self);
        while (av_read_frame(self->avFormatContext, &self->packet) >= 0) {
                if (self->packet.stream_index == self.videoStream) {
                    int ret = avcodec_send_packet(self->avCodecContext, &self->packet);
                    if (ret == 0) {
                        while (!avcodec_receive_frame(self->avCodecContext, self->avFrame)){
                            [self.mediaManager mediaVideoStream:self->avFrame codecContext:self->avCodecContext block:^(AFOVideoFrame *videoFrame) {
                            } ];
                            av_packet_unref(&self->packet);
                        }
                    }
                }
            }
    });
}
#pragma mark ------ freeFFMpeg
- (void)freeFFMpeg{
    if (_isFree) {
        return;
    }
    NSLog(@"释放资源");
    //------ 关闭解码器
    if (avCodecContext){
        avcodec_close(avCodecContext);
    };
    //------ 关闭文件
    if (avFormatContext){
        avformat_close_input(&avFormatContext);
    };
    ///------
    av_frame_free(&avFrame);
    ///------
    av_packet_unref(&packet);
    ///------
    avcodec_free_context(&avCodecContext);
    av_free(avFormatContext);
    ///------
    avCodec = NULL;
    ///------
    avformat_network_deinit();
    //
    _isFree = YES;
}
#pragma mark ------ dealloc
- (void)dealloc{
    [self freeFFMpeg];
}
#pragma mark ------------ property
#pragma mark ------ queue_t
- (dispatch_queue_t)queue_t{
    if (!_queue_t) {
        _queue_t = dispatch_queue_create("com.AFOGenerateImage.queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    }
    return _queue_t;
}
#pragma mark ------ mediaManager
- (AFOMediaManager *)mediaManager{
    if (!_mediaManager) {
        _mediaManager = [[AFOMediaManager alloc] init];
    }
    return _mediaManager;
}
@end
