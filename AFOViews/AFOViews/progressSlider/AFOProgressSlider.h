//
//  AFOProgressSlider.h
//  AFOViews
//
//  Created by xueguang xian on 2018/1/22.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFOSliderDirection){
    AFOSliderDirectionHorizonal  =   0,
    AFOSliderDirectionVertical   =   1
};
@interface AFOProgressSlider : UIControl
@property (nonatomic, assign) CGFloat minValue;//最小值
@property (nonatomic, assign) CGFloat maxValue;//最大值
@property (nonatomic, assign) CGFloat value;//滑动值
@property (nonatomic, assign) CGFloat sliderPercent;//滑动百分比
@property (nonatomic, assign) CGFloat progressPercent;//缓冲的百分比

@property (nonatomic, assign) BOOL    isSliding;

@property (nonatomic, assign) AFOSliderDirection direction;//方向

- (id)initWithFrame:(CGRect)frame direction:(AFOSliderDirection)direction;
@end
