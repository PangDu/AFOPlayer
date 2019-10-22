//
//  AFOHPDetailModel.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AFOHPDetailModel : NSObject
- (void)detailDataForValue:(NSString *)value
                      type:(id)type
                     block:(void(^)(NSArray *array))block;
+ (void)songsDetails:(id)object
               block:(void(^)(NSDictionary *dictionary))block;
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object;
+ (void)routerParams:(NSArray *)array
              indexPath:(NSIndexPath *)indexpath
                  block:(void (^)(NSURL *url))block;
@end
