//
//  AFOProgressSliderManager.m
//  AFOViews
//
//  Created by xueguang xian on 2018/1/28.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOProgressSliderManager.h"
#import "AFOProgressSlider.h"
@interface AFOProgressSliderManager ()
@property (nonatomic, copy)   NSString           *currentTime;
@property (nonatomic, strong) AFOProgressSlider  *progressSlider;
@property (nonatomic, strong) CADisplayLink      *displayLink;
@property (nonatomic, copy)   NSString           *strCurrent;
@property (nonatomic, copy)   NSString           *strTotal;
@property (nonatomic, assign)id<AFOProgressSliderManagerDelegate> delegate;
@property (nonatomic, assign, readwrite) CGFloat sliderPercent;
@end

@implementation AFOProgressSliderManager

#pragma mark ------ 
- (instancetype)initWithDelegate:(id)delegate{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}
#pragma mark ------
- (void)progressSliderManager:(void (^)(AFOProgressSlider *slider))block{
    block(self.progressSlider);
}
- (void)settingSliderPercent:(CGFloat)percent{
    self.progressSlider.sliderPercent = percent;
}
#pragma mark ------
- (void)settingProgressSlider:(CGFloat)current
                        total:(CGFloat)total
                        block:(void (^)(BOOL isEnd))block{
    if (current < total) {
        self.displayLink.paused = NO;
        [self settingSliderPercent:current / total];
        block(NO);
    }else if (current == total){
        self.displayLink.paused = YES;
        [self settingSliderPercent:0.0];
        block(YES);
    }
}
#pragma mark ------ settingDisplayLink
- (void)settingDisplayLink:(BOOL)isUse{
    self.displayLink.paused = isUse;
}
- (void)freeDisplayLink{
    [self.displayLink invalidate];
}
#pragma mark ------
- (void)updateProgressSlider{
    [self.delegate displayLinkUpdateDelegate];
}
- (void)progressValueChange{
    [self.delegate progressValueChangeDelegate];
}
#pragma mark ------------ property
- (CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgressSlider)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}
- (AFOProgressSlider *)progressSlider{
    if (!_progressSlider) {
        _progressSlider = [[AFOProgressSlider alloc] initWithFrame:CGRectZero direction:AFOSliderDirectionHorizonal];
        [_progressSlider addTarget:self action:@selector(progressValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _progressSlider;
}
- (CGFloat)sliderPercent{
    _sliderPercent = self.progressSlider.sliderPercent;
    return _sliderPercent;
}
#pragma mark ------------   dealloc
- (void)dealloc{
    NSLog(@"dealloc AFOProgressSliderManager");
}
@end
