//
//  KxMovieViewController+Extension.m
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/8.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import "KxMovieViewController+Extension.h"

@implementation KxMovieViewController (Extension)
- (NSString *)formatTimeInterval:(CGFloat)seconds left:(BOOL)isLeft{
    seconds = MAX(0, seconds);
    
    NSInteger s = seconds;
    NSInteger m = s / 60;
    NSInteger h = m / 60;
    
    s = s % 60;
    m = m % 60;
    
    NSMutableString *format = [(isLeft && seconds >= 0.5 ? @"-" : @"") mutableCopy];
    if (h != 0) [format appendFormat:@"%ld:%0.2ld", (long)h, (long)m];
    else        [format appendFormat:@"%ld", (long)m];
    [format appendFormat:@":%0.2ld", (long)s];
    
    return format;
}
@end
