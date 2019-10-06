//
//  AFOCountDownManagerDelegate.h
//  AFOFFMpeg
//
//  Created by xianxueguang on 2019/10/5.
//  Copyright © 2019年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFOCountDownManagerDelegate <NSObject>
@optional
- (void)vedioFilePlayingDelegate;
- (void)vedioFileSuspendedDelegate;
- (void)vedioFileFinishDelegate;
@end

NS_ASSUME_NONNULL_END
