//
//  AFOProgressSliderManager.h
//  AFOViews
//
//  Created by xueguang xian on 2018/1/28.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFOProgressSliderManagerDelegate <NSObject>
@optional
- (void)displayLinkUpdateDelegate;
- (void)progressValueChangeDelegate;
@end


@class AFOProgressSlider;
@interface AFOProgressSliderManager : NSObject
@property (nonatomic, assign, readonly) CGFloat sliderPercent;
- (instancetype)initWithDelegate:(id)delegate;
- (void)progressSliderManager:(void (^)(AFOProgressSlider *slider))block;
- (void)settingSliderPercent:(CGFloat)percent;
- (void)settingProgressSlider:(CGFloat)current
                        total:(CGFloat)total
                        block:(void (^)(BOOL isEnd))block;
- (void)settingDisplayLink:(BOOL)isUse;
- (void)freeDisplayLink;
@end
