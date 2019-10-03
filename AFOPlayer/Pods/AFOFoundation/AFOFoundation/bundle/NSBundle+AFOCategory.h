//
//  NSBundle+AFOCategory.h
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (AFOCategory)
+ (NSString *)imageNameFromBundle:(NSString *)bundleName
                           source:(NSString *)sourceName;
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName
                           podName:(NSString *)podName;
@end
