//
//  AFOPLMainManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol AFOPLMainManagerDelegate <NSObject>
@optional
- (void)mainManagerArray:(NSArray *)array
              indexArray:(NSArray *)indexArray;
@end
@interface AFOPLMainManager : NSObject
+ (AFOPLMainManager *)mainManagerDelegate:(id)managerDelegate;
+ (void)deleteMovieRelatedContentLocally:(NSArray *)array
                                   block:(void (^)(BOOL isSucess))block;
- (void)getThumbnailData:(void (^)(NSArray *array))block;
- (CGFloat)thumbnailHight:(NSIndexPath *)indexPath width:(CGFloat)width;
- (NSString *)vedioAddressIndexPath:(NSIndexPath *)indexPath;
- (NSString *)vedioNameIndexPath:(NSIndexPath *)indexPath;
- (UIInterfaceOrientationMask)orientationMask:(NSIndexPath *)indexPath;
@end
