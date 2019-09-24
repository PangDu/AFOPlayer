//
//  AFOAudioPacket.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/6.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "AFOAudioPacket.h"

@interface AFOAudioPacket(){
    short *audioBuffer;
}
@property (nonatomic, assign, readwrite) int bufferSize;
@end

@implementation AFOAudioPacket
- (instancetype)initWithBuffer:(short *)buffer
                          size:(int)size{
    if (self = [super init]) {
        audioBuffer = buffer;
        _bufferSize = size;
    }
    return self;
}
- (short *)returnBuffer{
    return audioBuffer;
}
- (void)dealloc{
    free(audioBuffer);
}
@end
