//
//  AFOHPListModel.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AFOHPListModel : NSObject

/**
 <#Description#>

 @param index <#index description#>
 @param block <#block description#>
 */
- (void)settingDataIndex:(NSInteger)index block:(void(^)(NSArray *array))block;

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
+ (void)settingAlbumObject:(id)object block:(void(^)(NSString *name))block;

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
