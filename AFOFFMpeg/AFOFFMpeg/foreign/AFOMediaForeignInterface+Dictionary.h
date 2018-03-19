//
//  AFOMediaForeignInterface+Dictionary.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/10.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <AFOFFMpeg/AFOFFMpeg.h>
@interface AFOMediaForeignInterface (Dictionary)
+ (NSString *)vedioName:(NSDictionary *)dic;
+ (NSString *)imageName:(NSDictionary *)dic;
+ (float)width:(NSDictionary *)dic;
+ (float)height:(NSDictionary *)dic;
@end
