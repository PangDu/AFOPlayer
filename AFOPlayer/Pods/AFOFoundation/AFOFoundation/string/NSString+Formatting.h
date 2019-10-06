//
//  NSString+Formatting.h
//  AFOFoundation
//
//  Created by xueguang xian on 2019/4/10.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Formatting)
+ (NSString *)md5HexDigest:(NSString *)input;
+ (NSString *)formatPlayTime:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
