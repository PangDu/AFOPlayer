//
//  AFOAudioDecoder.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AFOAudioDecoder : NSObject
- (void)audioDecoder:(nonnull AVFormatContext *)avFormatContext
        codecContext:(nonnull AVCodecContext *)avCodecContext
               codec:(nonnull AVCodec *)codec
               index:(NSInteger)index
          packetSize:(int)packetSize;
- (int)readAudioSamples:(short *)samples size:(int)size;
@end
NS_ASSUME_NONNULL_END
