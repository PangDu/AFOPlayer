//
//  AFOMediaSeekFrame+Conditional.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/18.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOMediaSeekFrame.h"


NS_ASSUME_NONNULL_BEGIN
typedef void(^MediaSeekFrameBlock)(NSError * error,
                                   NSInteger videoIndex,
                                   AVFormatContext *formatContext);
@interface AFOMediaSeekFrame (Conditional)
+ (void)mediaSesourcesConditionalPath:(NSString *)path
                        formatContext:(AVFormatContext *)avFormatContext
                         codecContext:(AVCodecContext *)avCodecContext
                                block:(MediaSeekFrameBlock) block;
+ (NSString *)vedioAddress:(NSString *)path
                      name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
