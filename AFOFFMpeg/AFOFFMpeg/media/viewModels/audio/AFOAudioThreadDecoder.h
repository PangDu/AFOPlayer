//
//  AFOAudioThreadDecoder.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/7.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AFOAudioFrame;
@interface AFOAudioThreadDecoder : NSObject
- (void)audioDecoder:(nonnull AVFormatContext *)avFormatContext
        codecContext:(nonnull AVCodecContext *)avCodecContext
               codec:(nonnull AVCodec *)codec
               index:(NSInteger)index;
- (void)packetBufferTimePercent:(float)timePercent;
- (void)readAudioPacket:(short *)samples size:(int)size;
@end

NS_ASSUME_NONNULL_END
