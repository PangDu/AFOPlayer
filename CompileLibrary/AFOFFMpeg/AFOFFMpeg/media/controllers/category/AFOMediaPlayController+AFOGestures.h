//
//  AFOMediaPlayController+AFOGestures.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <AFOFFMpeg/AFOFFMpeg.h>
@class AFOMediaView;
@interface AFOMediaPlayController (AFOGestures)
@property (nonatomic, strong) AFOMediaView           *mediaView;
- (void)addMeidaView;
- (void)settingMeidaViewImage:(UIImage *)image
                    totalTime:(NSString *)totalTime
                  currentTime:(NSString *)currentTime
                        total:(NSInteger)total
                      current:(NSInteger)current;
@end
