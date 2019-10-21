//
//  AFOHPPlayerView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPPlayerBaseView.h"
typedef void(^HPAVPlayerViewTimeBlock)(NSString *totalTime,
                                       NSString *playTime);
typedef void(^HPAVPlayerViewSliderBlock)(id model);
@interface AFOHPPlayerView : AFOHPPlayerBaseView
@property (nonatomic, copy) HPAVPlayerViewTimeBlock          timeBlock;
@property (nonatomic, copy) HPAVPlayerViewSliderBlock        sliderBlock;
@property (nonatomic, assign, readonly) CGSize               imageSize;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)sender;
@end
