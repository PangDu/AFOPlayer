//
//  AFOHPMPMediaQuery.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^localMPMediaBlock)(NSArray *array);
@interface AFOMPMediaQuery : NSObject

/**
 <#Description#>

 @param index <#index description#>
 @param block <#block description#>
 */
- (void)loadLocalMediaIndex:(NSInteger)index
                      block:(localMPMediaBlock)block;

/**
 <#Description#>

 @param artilst <#artilst description#>
 @param block <#block description#>
 */
- (void)artilstForSongList:(NSString *)artilst
                     block:(localMPMediaBlock)block;
- (void)artilstAndAlbumsForList:(NSString *)value
                       property:(id)property
                          block:(localMPMediaBlock)block;
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

 @param item <#item description#>
 @return <#return value description#>
 */
+ (NSURL *)mediaItemPropertyAssetURL:(id)item;

/**
 <#Description#>

 @param item <#item description#>
 @return <#return value description#>
 */
+ (NSString *)songName:(id)item;
@end
