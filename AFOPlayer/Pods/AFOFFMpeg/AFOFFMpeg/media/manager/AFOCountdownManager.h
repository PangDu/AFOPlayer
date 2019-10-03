//
//  AFOCountdownManager.h
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/31.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOCountdownManager : NSObject
@property (nonatomic, strong)     dispatch_queue_t     queues;

/**
 <#Description#>

 @param fps <#fps description#>
 @param time <#time description#>
 @param block <#block description#>
 */
- (void)addCountdownActionFps:(float)fps
                     duration:(int64_t)time
                     block:(void (^)(NSNumber *isEnd))block;
@end
