//
//  AFOMediaManager.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/1.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//
#import "AFOMediaDecoder.h"
#import <Foundation/Foundation.h>
@class AFOVideoFrame;
typedef void(^mediaManagerBlock)(AFOVideoFrame *videoFrame);
@interface AFOMediaDecoder : NSObject
- (void)displayVedioPath:(NSString *)strPath
                   block:(mediaManagerBlock)block;
- (void)abnormalConditionPath:(NSString *)strPath;
@end
