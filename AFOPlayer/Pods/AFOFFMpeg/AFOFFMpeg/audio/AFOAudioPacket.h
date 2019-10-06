//
//  AFOAudioPacket.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/6.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFOAudioPacket : NSObject
@property (nonatomic, assign, readonly) int bufferSize;
- (instancetype)initWithBuffer:(short *)buffer
                          size:(int)size;
- (short *)returnBuffer;
@end

NS_ASSUME_NONNULL_END
