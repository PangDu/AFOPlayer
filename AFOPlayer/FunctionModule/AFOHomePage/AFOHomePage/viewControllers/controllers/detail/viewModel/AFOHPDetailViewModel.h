//
//  AFOHPDetailViewModel.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^detailArtistListBlock)(NSArray *array);
typedef void(^detailArtistListDictionaryBlock)(NSDictionary *dictionary);
@interface AFOHPDetailViewModel : NSObject
- (void)detailDataForValue:(NSString *)value
                      type:(id)type
                     block:(detailArtistListBlock)block;
+ (void)songsDetails:(id)object
               block:(detailArtistListDictionaryBlock)block;
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object;
+ (void)routerParams:(NSArray *)array
              indexPath:(NSIndexPath *)indexpath
                  block:(void (^)(NSURL *url))block;
@end
