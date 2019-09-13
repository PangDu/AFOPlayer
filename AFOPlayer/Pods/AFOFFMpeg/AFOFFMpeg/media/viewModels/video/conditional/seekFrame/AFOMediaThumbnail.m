//
//  AFOMediaThumbnail.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/8.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaThumbnail.h"
#import <CommonCrypto/CommonDigest.h>
@implementation AFOMediaThumbnail
#pragma mark ------------ 视频地址
+ (NSString *)vedioAddress:(NSString *)path name:(NSString *)name{
    NSString *strPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    return strPath;
}
#pragma mark ------------ 生成图片地址
+ (NSString *)imageNameFromPath:(NSString *)path name:(NSString *)name{
    NSString *imagePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",[self imageName:name]]];
    return imagePath;
}
#pragma mark ------ 生成图片名
+ (NSString *)imageName:(NSString *)videoName{
    NSString *strImageName = [[AFOMediaThumbnail md5HexDigest:videoName] stringByAppendingString:@".jpg"];
    return strImageName;
}
#pragma mark ------------ 转化MD5
+ (NSString *)md5HexDigest:(NSString *)input{
    const char *cStr = [input UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
