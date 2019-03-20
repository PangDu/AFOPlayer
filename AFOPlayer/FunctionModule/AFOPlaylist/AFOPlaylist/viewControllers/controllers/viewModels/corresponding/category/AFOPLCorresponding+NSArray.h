//
//  AFOPLCorresponding+NSArray.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/15.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding.h"

@interface AFOPLCorresponding (NSArray)
+ (NSArray *)getUnscreenshotsArray:(NSArray *)data
                      compare:(NSArray *)compare;
+ (NSArray *)vedioName:(NSArray *)data;
+ (NSArray<NSIndexPath *> *)indexPathArray:(NSArray *)array;
+ (NSArray<NSIndexPath *> *)indexPathArray:(NSArray *)array
                                     index:(NSInteger)index;
@end
