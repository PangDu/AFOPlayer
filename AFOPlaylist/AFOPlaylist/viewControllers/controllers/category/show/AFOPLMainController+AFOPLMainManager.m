//
//  AFOPLMainController+AFOPLMainManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainController+AFOPLMainManager.h"
#import "AFOPLThumbnail.h"
#import "AFOPLMainManager.h"

@interface AFOPLMainController ()<AFOPLMainManagerDelegate>
@property (nonnull, nonatomic, strong, readwrite) AFOPLMainManager  *mainManager;
@property (nonnull, nonatomic, strong, readwrite) NSArray *dataArray;
@end
@implementation AFOPLMainController (AFOPLMainManager)
#pragma mark ------------ custom
#pragma mark ------
- (void)addCollectionViewData:(void (^)(NSArray *array,
                                        NSArray *indexArray,
                                        BOOL isHaveData))block{
    if (!self.mainManager) {
      self.mainManager = [AFOPLMainManager mainManagerDelegate:self];
    }
    WeakObject(self);
    [self.mainManager getThumbnailData:^(NSArray *array, NSArray *indexArray, BOOL isUpdate,BOOL isHaveData) {
        StrongObject(self);
        self.dataArray = [[NSArray alloc]initWithArray:array];
        block(array, indexArray,isHaveData);
    }];
}
#pragma mark ------
- (NSString *)vedioPath:(NSIndexPath *)indexPath{
    NSString *path = [self.mainManager vedioAddressIndexPath:indexPath];
    return path;
}
#pragma mark ------
- (NSString *)vedioName:(NSIndexPath *)indexPath{
    NSString *name = [self.mainManager vedioNameIndexPath:indexPath];
    return name;
}
#pragma mark ------
- (CGFloat)vedioItemHeight:(NSIndexPath *)indexPath width:(CGFloat)width{
    return [self.mainManager thumbnailHight:indexPath width:width];
}
#pragma mark ------ 
- (UIInterfaceOrientationMask)screenPortrait:(NSIndexPath *)indexPath{
    return [self.mainManager orientationMask:indexPath];
}
#pragma mark ------------ property
- (void)setMainManager:(AFOPLMainManager *)mainManager{
    objc_setAssociatedObject(self, @selector(setMainManager:), mainManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AFOPLMainManager *)mainManager{
    return objc_getAssociatedObject(self, @selector(setMainManager:));
}
- (void)setDataArray:(NSArray *)dataArray{
    objc_setAssociatedObject(self, @selector(setDataArray:), dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray *)dataArray{
    return objc_getAssociatedObject(self, @selector(setDataArray:));
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPLMainController+AFOPLMainManager dealloc");
}
@end
