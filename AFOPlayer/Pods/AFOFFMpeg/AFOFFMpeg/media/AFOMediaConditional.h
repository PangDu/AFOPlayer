//
//  AFOMediaConditional.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MediaConditionalBlock)(NSError *error,
                                     NSInteger videoIndex,
                                     NSInteger audioIndex);

@interface AFOMediaConditional : NSObject
+ (void)mediaSesourcesConditionalPath:(NSString *)path
                                block:(MediaConditionalBlock) block;
@end
