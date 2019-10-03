//
//  AFOVideoAudioManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/3.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFOMediaManager.h"
#import "AFOAudioManager.h"
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
@property (nonatomic, assign)            NSInteger  videoStream;
@property (nonatomic, assign)            NSInteger  audioStream;
@property (nonatomic, assign)            float      audioTimeStamp;
@property (nonatomic, assign)            float      videoTimeStamp;
@property (nonatomic, assign)            float      videoPosition;
@property (nonatomic, assign)            CGFloat    tickCorrectionTime;
@property (nonatomic, assign)            float      tickCorrectionPosition;
@property (nonatomic, assign)            float      frameRate;
@property (nonnull, nonatomic, strong)   AFOAudioManager      *audioManager;
@property (nonnull, nonatomic, strong)   AFOMediaManager  *videoManager;
/**
 <#Description#>
 
 @param strPath <#strPath description#>
 @param block <#block description#>
 */
- (void)displayVedioForPath:(NSString *)strPath
                           block:(displayVedioBlock)block;
@end

NS_ASSUME_NONNULL_END
