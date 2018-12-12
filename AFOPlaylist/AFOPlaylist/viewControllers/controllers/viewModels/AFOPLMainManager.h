//
//  AFOPLMainManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFOPLMainManagerDelegate <NSObject>
@optional
- (void)mainManagerArray:(NSArray *)array
              indexArray:(NSArray *)indexArray;
@end
@interface AFOPLMainManager : NSObject
+ (AFOPLMainManager *)mainManagerDelegate:(id)managerDelegate;
+ (void)deleteMovieRelatedContentLocally;
- (void)getThumbnailData:(void (^)(NSArray *array,
                                   NSArray *indexArray,
                                   BOOL isUpdate))block;
- (CGFloat)thumbnailHight:(NSIndexPath *)indexPath width:(CGFloat)width;
- (NSString *)vedioAddressIndexPath:(NSIndexPath *)indexPath;
- (NSString *)vedioNameIndexPath:(NSIndexPath *)indexPath;
@end
