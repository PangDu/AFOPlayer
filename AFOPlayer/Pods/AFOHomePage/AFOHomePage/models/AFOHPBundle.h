//
//  AFOHPBundle.h
//  AFOHomePage
//
//  Created by piccolo on 2019/9/25.
//  Copyright © 2019 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface AFOHPBundle : NSObject
+ (NSString *)bundleName:(NSString *)bundleName
                 podName:(NSString *)podName
                resource:(NSString *)resource
                    type:(NSString *)type;
+ (UIImage *)imageNamedFromBundle:(NSString *)name type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
