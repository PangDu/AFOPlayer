//
//  AFOHPDetailModel.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <MediaPlayer/MPMediaItem.h>
#import <UIKit/UIKit.h>
#import <AFOFoundation/AFOFoundation.h>
#import <AFORouter/AFORouter.h>
#import "AFOHPDetailModel.h"
#import "AFOMPMediaQuery.h"
@interface AFOHPDetailModel()
@property (nonatomic, strong) AFOMPMediaQuery *mediaQuery;
@end
@implementation AFOHPDetailModel
#pragma mark ------------ custom
#pragma mark ------ 获取列表
- (void)detailDataForValue:(NSString *)value
                      type:(id)type
                     block:(void(^)(NSArray *array))block{
    id strType = MPMediaItemPropertyArtist;
    if ([type integerValue] == 2) {
        strType = MPMediaItemPropertyAlbumTitle;
    }else if ([type integerValue] == 3){
        strType = MPMediaItemPropertyTitle;
    }
    [self.mediaQuery artilstAndAlbumsForList:value property:strType block:^(NSArray *array) {
        block(array);
    }];
}
#pragma mark ------ 获取歌曲详情
+ (void)songsDetails:(id)object block:(void(^)(NSDictionary *dictionary))block{
    if ([object isKindOfClass:[MPMediaItem  class]]){
        MPMediaItem *item = object;
        
        NSDictionary *dic = @{@"albumTitle" : [NSString stringWithFormat:@"出自 %@ 专辑",item.albumTitle],
                              
                              @"title" : item.title,
                              
                              @"assetURL" : item.assetURL
                              };
        block(dic);
    }
}
#pragma mark ------
+ (UIImage *)albumImageWithSize:(CGSize)size
                         object:(id)object{
    return [AFOMPMediaQuery albumImageWithSize:size object:object];
}
#pragma mark ------ 
+ (void)routerParams:(NSArray *)array
              indexPath:(NSIndexPath *)indexpath
                  block:(void (^)(NSURL *url))block{
    if (!array) {
        return;
    }
    id model = array[indexpath.row];
    __block NSURL *baseUrl = NULL;
    [AFOHPDetailModel songsDetails:model block:^(NSDictionary *dictionary) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
        [dic setObject:@"homePage" forKey:@"modelName"];
        [dic setObject:@"AFOHPDetailController"  forKey:@"current"];
        [dic setObject:@"AFOHPVedioController" forKey:@"next"];
        [dic setObject:@"push" forKey:@"action"];
//        NSString *strBase = [[AFORouterManager shareInstance] settingPushControllerRouter:@"AFOHPVedioController" present:@"AFOHPDetailController" params:dictionary];
        baseUrl = [NSURL URLWithString:[NSString settingRoutesParameters:dic]];
    }];
    block(baseUrl);
}
#pragma mark ------------ property
- (AFOMPMediaQuery *)mediaQuery{
    if (!_mediaQuery) {
        _mediaQuery = [[AFOMPMediaQuery alloc] init];
    }
    return _mediaQuery;
}
@end
