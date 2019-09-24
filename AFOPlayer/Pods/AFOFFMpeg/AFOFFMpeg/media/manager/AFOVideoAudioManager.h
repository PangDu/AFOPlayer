//
//  AFOVideoAudioManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 <#Description#>
 
 @param error <#error description#>
 @param image <#image description#>
 @param totalTime <#totalTime description#>
 @param currentTime <#currentTime description#>
 @param totalSeconds <#totalSeconds description#>
 @param cuttentSeconds <#cuttentSeconds description#>
 */
typedef void(^displayVedioBlock)(NSError *_Nullable error,
                                UIImage  *_Nullable image,
                                NSString *_Nullable totalTime,
                                NSString *_Nullable currentTime,
                                NSInteger totalSeconds,
                                NSUInteger cuttentSeconds);
NS_ASSUME_NONNULL_BEGIN

@interface AFOVideoAudioManager : NSObject
/**
 <#Description#>
 
 @param strPath <#strPath description#>
 @param block <#block description#>
 */
- (void)displayVedioForPath:(NSString *)strPath
                           block:(displayVedioBlock)block;
@end

NS_ASSUME_NONNULL_END
