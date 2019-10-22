//
//  AFOMediaThumbnail.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/8.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOMediaThumbnail : NSObject
/**
 <#Description#>

 @param path <#path description#>
 @param name <#name description#>
 @return <#return value description#>
 */
+ (NSString *)vedioAddress:(NSString *)path name:(NSString *)name;


/**
 <#Description#>

 @param videoName <#videoName description#>
 @return <#return value description#>
 */
+ (NSString *)imageName:(NSString *)videoName;
/**
 <#Description#>

 @param path <#path description#>
 @param name <#name description#>
 @return <#return value description#>
 */
+ (NSString *)imageNameFromPath:(NSString *)path name:(NSString *)name;
@end
