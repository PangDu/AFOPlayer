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
@property (nonatomic, strong) AFOPLMainManager  *mainManager;
- (void)addCollectionViewData:(void (^)(NSArray *array,
                                        NSArray *indexArray))block;
- (NSString *)vedioPath:(NSIndexPath *)indexPath;
- (NSString *)vedioName:(NSIndexPath *)indexPath;
- (CGFloat)vedioItemHeight:(NSIndexPath *)indexPath width:(CGFloat)width;
- (UIInterfaceOrientationMask)screenPortrait:(NSIndexPath *)indexPath;
@end
