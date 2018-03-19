//
//  AFOPlayMediaViewModel.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2017/12/28.
//  Copyright © 2017年 AFO Science and technology Ltd. All rights reserved.
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
typedef void(^displayVedioFrameBlock)(NSError * error,
                                      UIImage *image,
                                      NSString *totalTime,
                                      NSString *currentTime,
                                      NSInteger totalSeconds,
                                      NSUInteger cuttentSeconds);

@interface AFOPlayMediaManager : NSObject
/**
 <#Description#>

 @param strPath <#strPath description#>
 @param block <#block description#>
 */
- (void)displayVedioFrameForPath:(NSString *)strPath
                           block:(displayVedioFrameBlock)block;

@end
