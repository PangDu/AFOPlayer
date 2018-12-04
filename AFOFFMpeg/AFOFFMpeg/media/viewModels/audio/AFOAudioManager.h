//
//  AFOAudioManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/3/20.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOAudioManager : NSObject
+ (instancetype)shareAFOAudioManager;
- (void)playAudioCodec:(AVCodec *)codec
         formatContext:(AVFormatContext *)formatContext
          codecContext:(AVCodecContext *)codecContext
                 index:(NSInteger)index;
- (void)stopAudioContent;
@end
