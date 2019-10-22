//
//  AFOMediaThumbnail.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/8.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaThumbnail.h"
#import <AFOFoundation/NSString+Formatting.h>
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
    NSString *strImageName = [[NSString md5HexDigest:videoName] stringByAppendingString:@".jpg"];
    return strImageName;
}
@end
