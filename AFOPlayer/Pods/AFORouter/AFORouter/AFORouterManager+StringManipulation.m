//
//  AFORouterManager+StringManipulation.m
//  AFORouter
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFORouterManager+StringManipulation.h"

@implementation AFORouterManager (StringManipulation)
#pragma mark ------ 参数放到URL尾部
- (NSString*)addQueryStringToUrl:(NSString *)url params:(NSDictionary *)params {
    __block NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:url];
    // 转换参数
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *sKey = [key description];
            NSString *sVal = [[[params objectForKey:key] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // 需要添加 add ?k=v or &k=v ?
            if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
                [urlWithQuerystring appendFormat:@"?%@=%@", sKey, sVal];
            } else {
                [urlWithQuerystring appendFormat:@"&%@=%@", sKey, sVal];
            }
        }];
    }
    return urlWithQuerystring;
}
#pragma mark ------
- (NSString *)settingPushControllerRouter:(id)controller
                                   scheme:(NSString *)scheme
                                   params:(NSDictionary *)dictionary{
    NSString *strResult;
    NSString *strBase =[scheme stringByAppendingString:@"://push/"];
    if ([controller isKindOfClass:[UIViewController class]]) {
        NSString *strCon = NSStringFromClass([controller class]);
        strResult = [strBase stringByAppendingString:strCon];
    }else{
        strResult = [strBase stringByAppendingString:controller];
    }
    if (dictionary.count > 0) {
        strResult = [self addQueryStringToUrl:strResult params:dictionary];
    }
    return strResult;
}
#pragma mark ------
- (NSString *)settingPushControllerRouter:(id)controller
                                  present:(id)present
                                   scheme:(NSString *)scheme
                                   params:(NSDictionary *)dictionary{
    NSString *strResult;
    NSString *strBase =[scheme stringByAppendingString:@"://push/"];
    if (controller != nil && present != nil) {
        strResult = [strBase stringByAppendingString:present];
        strResult = [strResult stringByAppendingString:@"/"];
        strResult = [strResult stringByAppendingString:controller];
    }else{
        strResult = [strBase stringByAppendingString:controller];
    }
    if (dictionary.count > 0) {
        strResult = [self addQueryStringToUrl:strResult params:dictionary];
    }
    return strResult;
}
@end
