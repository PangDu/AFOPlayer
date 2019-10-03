//
//  AFOHPBundle.m
//  AFOHomePage
//
//  Created by piccolo on 2019/9/25.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPBundle.h"
#import <AFOFoundation/NSBundle+AFOCategory.h>
@implementation AFOHPBundle
+ (NSString *)bundleName:(NSString *)bundleName
                 podName:(NSString *)podName
                resource:(NSString *)resource
                    type:(NSString *)type{
    NSBundle *home = [NSBundle bundleWithBundleName:bundleName podName:podName];
    NSString *path = [home pathForResource:resource ofType:type];
    return path;
}
+ (UIImage *)imageNamedFromBundle:(NSString *)name type:(NSString *)type{
    
    NSBundle *imageBundle = [self homePageBundle];
    NSString *imagePath = [imageBundle pathForResource:name ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}
+ (NSBundle *)homePageBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"AFOHomePage" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}
@end
