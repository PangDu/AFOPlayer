//
//  AFOHPAVPlayerView.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFOHPAVPlayerViewDelegate
@optional
- (void)settingSongName:(NSString *)name;
@end

@interface AFOHPAVPlayerView : UIView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)sender;
- (void)settingValue:(id)model dictionary:(NSDictionary *)dicionary;
- (void)displayLinkPause;
@end
