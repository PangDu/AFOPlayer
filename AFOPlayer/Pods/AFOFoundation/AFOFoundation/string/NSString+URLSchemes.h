//
//  NSString+URLSchemes.h
//  AFOFoundation
//
//  Created by xianxueguang on 2019/9/30.
//  Copyright © 2019年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLSchemes)
+ (NSString *)readSchemesFromInfoPlist;
@end

NS_ASSUME_NONNULL_END
