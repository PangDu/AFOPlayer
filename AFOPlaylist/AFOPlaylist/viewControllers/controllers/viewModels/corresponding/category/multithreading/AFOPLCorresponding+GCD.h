//
//  AFOPLCorresponding+GCD.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding.h"

@interface AFOPLCorresponding (GCD)
- (void)cuttingImageSaveSqlite:(NSArray *)array
                         block:(void (^) (NSArray *itemArray))block;
@end
