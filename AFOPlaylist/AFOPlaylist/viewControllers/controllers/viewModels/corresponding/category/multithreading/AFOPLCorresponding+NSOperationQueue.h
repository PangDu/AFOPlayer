//
//  AFOPLCorresponding+NSOperationQueue.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding.h"

@interface AFOPLCorresponding (NSOperationQueue)
@property (nonnull, nonatomic, strong)   NSOperationQueue *operationQueue;
- (void)useOperationQueue:(NSArray *)saveArray
                    array:(NSArray *)array
                    block:(void (^) (NSArray * array))block;
@end
