//
//  AFONewMediaManager.h
//  AFOFFMpeg
//
//  Created by xianxueguang on 2019/10/3.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import <AFOFFMpeg/AFOFFMpeg.h>
#import "AFOVideoAudioManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface AFONewMediaManager : AFOVideoAudioManager
- (void)registerAudioBaseMethod:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
