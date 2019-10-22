//
//  AFOMediaSeekFrame.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/5.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^mediaSeekFrameBlock)(BOOL isWrite,
                                   BOOL isCutting);
typedef void(^mediaSeekFrameDetailBlock)(BOOL isWrite,
                                         BOOL isCutting,
                                         NSString *createTime,
                                         NSString *vedioName,
                                         NSString *imageName,
                                         int width,
                                         int height);
@interface AFOMediaSeekFrame : NSObject
+ (instancetype)vedioName:(NSString *)name
                     path:(NSString *)path
                imagePath:(NSString *)imagePath
                    plist:(NSString *)plist
                    block:(mediaSeekFrameDetailBlock)block;
@end
