//
//  AFOMediaForeignInterface+Array.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/10.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <AFOFFMpeg/AFOFFMpeg.h>

@interface AFOMediaForeignInterface (Array)
- (void)getUnscreenshotsArray:(NSArray *)data
                      compare:(NSArray *)compare
                        block:(void (^)(NSArray *array))block;

@end
