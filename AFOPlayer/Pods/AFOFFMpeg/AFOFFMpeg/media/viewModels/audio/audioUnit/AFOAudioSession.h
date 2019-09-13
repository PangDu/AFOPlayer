//
//  AFOAudioSession.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFOAudioSession : NSObject
- (void)settingSampleRate:(Float64)sampleRate;
- (void)settingCategory:(NSString *)category;
- (void)settingPreferredLatency:(NSTimeInterval)preferredLatency;
- (void)settingActive:(BOOL)active;
@end

NS_ASSUME_NONNULL_END
