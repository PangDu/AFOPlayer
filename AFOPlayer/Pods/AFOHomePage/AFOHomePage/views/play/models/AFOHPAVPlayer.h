//
//  AFOHPAVPlayer.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AFOHPAVPlayerSelectMusic){
    AFOHPAVPlayerSelectMusicPlay   =   0,
    AFOHPAVPlayerSelectMusicOn     =   1,
    AFOHPAVPlayerSelectMusicNext   =   2
};
@protocol AFOHPAVPlayerDelegate
@optional
- (void)audioTotalTime:(NSString *)totalTime;
- (void)audioPlayWithEnter;
- (void)audioOperationPlay:(id)model;
@end
@interface AFOHPAVPlayer : NSObject
@property (nonatomic, weak) id<AFOHPAVPlayerDelegate>delegate;
- (instancetype)initWithDelegate:(id)delegate;
- (void)addPlayerItem:(id)model;
- (void)settingAVPlayerPause:(BOOL)isPause;
- (void)changeSliderValue:(CGFloat)percent;
- (void)updateProgressSlider:(void (^) (NSTimeInterval currentTime,
                                        NSTimeInterval totalTime))block;
- (void)selectMusicPlayer:(AFOHPAVPlayerSelectMusic)type;
- (id)getCurrentSongImage:(id)model dictionary:(NSDictionary *)dictionary;
- (NSString *)totalTimer;
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object;
+ (NSString *)songName:(id)object;
@end
