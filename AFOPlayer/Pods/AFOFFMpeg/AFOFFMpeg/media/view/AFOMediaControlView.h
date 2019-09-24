//
//  AFOMediaControlView.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFOMediaControlViewDelegate
@optional
- (void)buttonTouchActionDelegate:(BOOL)isSuspended;
@end

@interface AFOMediaControlView : UIControl
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;
- (void)settingPlayButtonPause;
- (void)settingTime:(NSString *)totalTime
        currentTime:(NSString *)currentTime
              total:(NSInteger)total
            current:(NSInteger)current
              block:(void (^)(BOOL isEnd))block;
@end
