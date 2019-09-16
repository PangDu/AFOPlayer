//
//  AFOAudioManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOFFMpegHeader.h"
@protocol AFOAudioManagerDelegate <NSObject>
@optional
- (void)audioTimeStamp:(float)audioTime;
@end
@interface AFOAudioManager : NSObject
- (instancetype)initWithDelegate:(id<AFOAudioManagerDelegate>)delegate;
- (void)audioFormatContext:(AVFormatContext *)formatContext
              codecContext:(AVCodecContext *)codecContext
                     index:(NSInteger)index;
- (void)playAudio;
- (void)stopAudio;
@end
