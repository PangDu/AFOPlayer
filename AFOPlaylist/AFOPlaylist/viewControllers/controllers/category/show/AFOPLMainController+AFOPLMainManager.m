//
//  AFOPLMainController+AFOPLMainManager.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLMainController+AFOPLMainManager.h"
@interface AFOPLMainController ()<AFOPLMainManagerDelegate>
@property (nonnull, nonatomic, strong, readwrite) AFOPLMainManager  *mainManager;
@property (nonnull, nonatomic, strong, readwrite) NSMutableArray *dataArray;
@end
@implementation AFOPLMainController (AFOPLMainManager)
#pragma mark ------ 获取数据
- (void)addCollectionViewData:(void (^)(NSArray *array))block{
    if (!self.mainManager) {
      self.mainManager = [AFOPLMainManager mainManagerDelegate:self];
    }
    if (!self.dataArray) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    WeakObject(self);
    [self.mainManager getThumbnailData:^(NSArray *array) {
        StrongObject(self);
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:array];
        block(array);
    }];
}
#pragma mark ------ 视频地址
- (NSString *)vedioPath:(NSIndexPath *)indexPath{
    NSString *path = [self.mainManager vedioAddressIndexPath:indexPath];
    return path;
}
#pragma mark ------ 视频名称
- (NSString *)vedioName:(NSIndexPath *)indexPath{
    NSString *name = [self.mainManager vedioNameIndexPath:indexPath];
    return name;
}
#pragma mark ------ 图片高度
- (CGFloat)vedioItemHeight:(NSIndexPath *)indexPath width:(CGFloat)width{
    return [self.mainManager thumbnailHight:indexPath width:width];
}
#pragma mark ------ 横竖屏切换
- (UIInterfaceOrientationMask)screenPortrait:(NSIndexPath *)indexPath{
    return [self.mainManager orientationMask:indexPath];
}
#pragma mark ------ property
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
