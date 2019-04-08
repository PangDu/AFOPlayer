//
//  AFOHPListModel.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 <#Description#>

 @param array <#array description#>
 */
typedef void(^artistsListBlock)(NSArray *array);

/**
 <#Description#>

 @param name <#name description#>
 */
typedef void(^albumDetailBlock)(NSString *name);
@interface AFOHPListModel : NSObject

/**
 <#Description#>

 @param index <#index description#>
 @param block <#block description#>
 */
- (void)settingDataIndex:(NSInteger)index block:(artistsListBlock)block;

/**
 <#Description#>

 @param array <#array description#>
 */
- (void)settingDataArray:(NSArray *)array;

/**
 <#Description#>

 @param object <#object description#>
 @param block <#block description#>
 */
- (void)settingAlbumObject:(id)object block:(albumDetailBlock)block;

/**
 <#Description#>

 @param index <#index description#>
 @return <#return value description#>
 */
- (NSString *)artistsNameIndex:(NSInteger)index;

/**
 <#Description#>

 @param object <#object description#>
 @return <#return value description#>
 */
+ (NSString *)artistsNameObject:(id)object;

/**
 <#Description#>

 @param size <#size description#>
 @param object <#object description#>
 @return <#return value description#>
 */
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object;

/**
 <#Description#>

 @param indexPath <#indexPath description#>
 @return <#return value description#>
 */
- (NSURL *)settingRouterUrl:(NSIndexPath *)indexPath;
@end
