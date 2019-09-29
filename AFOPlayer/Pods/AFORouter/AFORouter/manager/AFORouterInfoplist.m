//
//  AFORouterInfoplist.m
//  AFORouter
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFORouterInfoplist.h"

@implementation AFORouterInfoplist
+ (NSString *)readAppInfoPlistFile{
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
