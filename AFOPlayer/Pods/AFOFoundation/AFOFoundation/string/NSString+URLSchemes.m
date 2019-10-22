//
//  NSString+URLSchemes.m
//  AFOFoundation
//
//  Created by xianxueguang on 2019/9/30.
//  Copyright © 2019年 AFO Science Technology Ltd. All rights reserved.
//

#import "NSString+URLSchemes.h"

@implementation NSString (URLSchemes)
+ (NSString *)readSchemesFromInfoPlist{
    NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
    __block NSArray *key = nil;
    if ([dict objectForKey:@"CFBundleURLTypes"] && [[dict objectForKey:@"CFBundleURLTypes"] isKindOfClass:[NSArray class]]) {
        NSArray *array = [dict objectForKey:@"CFBundleURLTypes"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            if (dic[@"CFBundleURLSchemes"]) {
                key = dic[@"CFBundleURLSchemes"];
            }
        }];
    }
    return [key lastObject];
}
@end
