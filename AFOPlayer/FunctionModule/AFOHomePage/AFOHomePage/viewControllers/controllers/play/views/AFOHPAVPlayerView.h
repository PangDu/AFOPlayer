//
//  AFOHPAVPlayerView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPPlayerBaseView.h"
typedef void(^AFOHPAVPlayerViewBlock)(UIImage *image);
typedef void(^HPAVPlayerViewTotalTimeBlock)(NSString *totalTime);
typedef void(^HPAVPlayTimeBlock)(NSString *playTime, BOOL isSelect);
typedef void(^HPAVPlayerViewEnterBlock)(void);
typedef void(^HPAVPlayerViewSliderBlock)(id model);
@interface AFOHPAVPlayerView : AFOHPPlayerBaseView
@property (nonatomic, copy) AFOHPAVPlayerViewBlock           block;
@property (nonatomic, copy) HPAVPlayerViewTotalTimeBlock     totalTimeBlock;
@property (nonatomic, copy) HPAVPlayerViewEnterBlock         enterBlock;
@property (nonatomic, copy) HPAVPlayTimeBlock                playTimeBlock;
@property (nonatomic, copy) HPAVPlayerViewSliderBlock        sliderBlock;
@property (nonatomic, assign, readonly) CGSize               imageSize;
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)sender;
@end
