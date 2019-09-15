//
//  AFOAudioCache.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/7.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFOAudioCache : NSObject
- (instancetype)initWithCap:(NSInteger)cap
                    markCap:(NSInteger)markCap
                    timeout:(NSTimeInterval)timeout;
@end

NS_ASSUME_NONNULL_END
