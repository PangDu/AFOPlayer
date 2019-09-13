//
//  NSBundle+AFOCategory.m
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSBundle+AFOCategory.h"

@implementation NSBundle (AFOCategory)
#pragma mark ------------ 获取bundel图片
+ (NSString *)imageNameFromBundle:(NSString *)bundleName
                           source:(NSString *)sourceName{
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName];
    NSString *strImage = [bundlePath stringByAppendingPathComponent:sourceName];
    return strImage;
}
@end
