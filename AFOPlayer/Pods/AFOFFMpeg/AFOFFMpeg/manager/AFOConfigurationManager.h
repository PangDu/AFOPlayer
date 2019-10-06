//
//  AFOConfigurationManager.h
//  AFOFFMpeg
//
//  Created by xianxueguang on 2019/10/4.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libavformat/avformat.h>
NS_ASSUME_NONNULL_BEGIN

@interface AFOConfigurationManager : NSObject
+ (void)configurationForPath:(NSString *)strPath
                      stream:(NSInteger)stream
                       block:(void(^)(
                                      AVCodec *codec,
                                      AVFormatContext *format, AVCodecContext *context,
                                      NSInteger videoStream,
                                      NSInteger audioStream))block;
+ (void)configurationStreamPath:(NSString *)strPath
                          block:(void(^)(NSError *error,
                                         NSInteger videoIndex,
                                         NSInteger audioIndex))block;
@end

NS_ASSUME_NONNULL_END
