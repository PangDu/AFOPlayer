//
//  AFOHPListViewModel.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//
#import <MediaPlayer/MPMediaItemCollection.h>
#import "AFOHPListViewModel.h"
#import "AFOMPMediaQuery.h"
@interface AFOHPListViewModel ()
@property (nonatomic, assign) NSInteger          type;
@property (nonatomic, strong) NSMutableArray    *artistsArray;
@property (nonatomic, strong) AFOMPMediaQuery   *mediaQuery;
@end
@implementation AFOHPListViewModel
#pragma mark ------------ custom
#pragma mark ------ 获取数据源
- (void)settingDataIndex:(NSInteger)index block:(artistsListBlock)block{
    self.type = index;
    __weak typeof(self) weakSelf = self;
    [self.mediaQuery loadLocalMediaIndex:index block:^(NSArray *array) {
        [weakSelf settingDataArray:array];
        block(array);
    }];
}
#pragma mark ------ 设置数据源
- (void)settingDataArray:(NSArray *)array{
    [self.artistsArray removeAllObjects];
    [self.artistsArray addObjectsFromArray:array];
}
#pragma mark---------------------------- 艺术家相关
#pragma mark ------ 获取艺术家名
- (NSString *)artistsNameIndex:(NSInteger)index{
    return [AFOHPListViewModel artistsNameObject:self.artistsArray[index]];
}
#pragma mark ------ 根据MPMediaItemCollection获取艺术家
+ (NSString *)artistsNameObject:(id)object{
    if ([object isKindOfClass:[MPMediaItemCollection class]]) {
        MPMediaItemCollection *item = object;
        return item.representativeItem.artist;
    };
    return @"";
}
#pragma mark---------------------------- 专辑相关
#pragma mark ------ 专辑集合
- (void)settingAlbumObject:(id)object block:(albumDetailBlock)block{
    if ([object isKindOfClass:[MPMediaItemCollection class]]) {
        MPMediaItemCollection *item = object;
        block(item.representativeItem.albumTitle);
    };
}
#pragma mark ------ 专辑名
- (NSString *)albumTitleNameIndex:(NSInteger)index{
    return [AFOHPListViewModel albumTitleNameObject:self.artistsArray[index]];
}
#pragma mark ------ 根据MPMediaItemCollection获取专辑
+ (NSString *)albumTitleNameObject:(id)object{
    if ([object isKindOfClass:[MPMediaItemCollection class]]) {
        MPMediaItemCollection *item = object;
        return item.representativeItem.albumTitle;
    };
    return @"";
}
#pragma mark ------ 获取专辑图片
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object{
    if ([object isKindOfClass:[MPMediaItemCollection class]]) {
        MPMediaItemCollection *item = object;
        object = item.representativeItem;
    }
    return [AFOMPMediaQuery albumImageWithSize:size object:object];
}
#pragma mark ------ router URL组装
- (NSURL *)settingRouterUrl:(NSIndexPath *)indexPath{
    NSString *string ;
    if (self.type == 1) {
        string = [self artistsNameIndex:indexPath.row];
    }else if(self.type == 2){
        string = [self albumTitleNameIndex:indexPath.row];
    }
    if (string == nil || string.length < 1) {
        return nil;
    }
    NSString *strBase = [[AFORouterManager shareInstance] settingPushControllerRouter:@"AFOHPDetailController" present:NSStringFromClass([self class]) params:@{@"value": string,@"type" : @(self.type)}];
    return [NSURL URLWithString:strBase];
}
#pragma mark ------------ property
#pragma mark ------ artistsArray
- (NSMutableArray *)artistsArray{
    if (!_artistsArray) {
        _artistsArray = [[NSMutableArray alloc] init];
    }
    return _artistsArray;
}
#pragma mark ------ mediaQuery
- (AFOMPMediaQuery *)mediaQuery{
    if (!_mediaQuery) {
        _mediaQuery = [[AFOMPMediaQuery alloc] init];
    }
    return _mediaQuery;
}
@end
