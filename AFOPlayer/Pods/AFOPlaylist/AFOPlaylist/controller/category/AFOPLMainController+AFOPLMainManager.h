//
//  AFOPLMainController+AFOPLMainManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainController.h"
@class AFOPLMainManager;
@interface AFOPLMainController (AFOPLMainManager)
@property (nonnull, nonatomic, strong, readonly) AFOPLMainManager  *mainManager;
@property (nonnull ,nonatomic, strong, readonly) NSArray *dataArray;
- (void)addCollectionViewData:(void (^_Nullable)(NSArray * _Nullable array))block;
- (NSString *_Nullable)vedioPath:(NSIndexPath *_Nullable)indexPath;
- (NSString *_Nullable)vedioName:(NSIndexPath *_Nullable)indexPath;
- (CGFloat)vedioItemHeight:(NSIndexPath *_Nullable)indexPath width:(CGFloat)width;
- (UIInterfaceOrientationMask)screenPortrait:(NSIndexPath *_Nullable)indexPath;
@end
