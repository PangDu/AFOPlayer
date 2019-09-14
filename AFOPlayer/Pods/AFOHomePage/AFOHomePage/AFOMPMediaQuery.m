//
//  AFOHPMPMediaQuery.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMPMediaQuery.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AFOMPMediaQuery ()
@property (nonatomic, strong) MPMediaQuery *mediaQuery;
@end

@implementation AFOMPMediaQuery
#pragma mark ------------ 自定义
#pragma mark ------ 
- (void)loadLocalMediaIndex:(NSInteger)index
                      block:(localMPMediaBlock)block{
    if (index == 0) {
     self.mediaQuery.groupingType = MPMediaGroupingArtist;
    }else if (index == 1){
     self.mediaQuery.groupingType = MPMediaGroupingAlbum;
    }else if (index == 2){
     self.mediaQuery.groupingType = MPMediaGroupingTitle;
    }
    [self loadItemForGroupingTypeBlock:^(NSArray *array) {
        block(array);
    }];
};
#pragma mark ------ 根据groupingType获取数据
- (void)loadItemForGroupingTypeBlock:(localMPMediaBlock)block{
    NSArray *localArray = self.mediaQuery.collections;
    __block NSMutableArray *data = [[NSMutableArray alloc] init];
    [localArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MPMediaItemCollection *item = obj;
        [data addObject:item];
    }];
    block(data);
}
#pragma mark ------
- (void)artilstAndAlbumsForList:(NSString *)value
                       property:(id)property
                          block:(localMPMediaBlock)block{
    if ([property isEqualToString:MPMediaItemPropertyTitle]) {
        block([MPMediaQuery songsQuery].items);
    }else{
        MPMediaPropertyPredicate *artistNamePredicate =
        [MPMediaPropertyPredicate predicateWithValue: value
                                         forProperty: property];
        [self.mediaQuery addFilterPredicate: artistNamePredicate];
        NSArray *itemsFromArtistQuery = [self.mediaQuery items];
        block(itemsFromArtistQuery);
    }
}
#pragma mark ------ 获取艺术家的所有歌曲
- (void)artilstForSongList:(NSString *)artilst block:(localMPMediaBlock)block{
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: artilst
                                     forProperty: MPMediaItemPropertyArtist];
    [self.mediaQuery addFilterPredicate: artistNamePredicate];
    NSArray *itemsFromArtistQuery = [self.mediaQuery items];
    block(itemsFromArtistQuery);
}
#pragma mark ------ 获取专辑下所有歌曲
- (void)albumsForSongList:(NSString *)album block:(localMPMediaBlock)block{
    MPMediaPropertyPredicate *artistNamePredicate =
    [MPMediaPropertyPredicate predicateWithValue: album
                                     forProperty: MPMediaItemPropertyTitle];
    [self.mediaQuery addFilterPredicate: artistNamePredicate];
    NSArray *itemsFromArtistQuery = [self.mediaQuery items];
    block(itemsFromArtistQuery);
}
#pragma mark ------ 专辑图片
+ (UIImage *)albumImageWithSize:(CGSize)size object:(id)object{
    MPMediaItemArtwork *artwork = [object valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *image = [artwork imageWithSize:size];
    return image;
}
#pragma mark ------
+ (NSURL *)mediaItemPropertyAssetURL:(id)item{
    MPMediaItem *mediaItem = item;
    return [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
}
#pragma mark ------
+ (NSString *)songName:(id)item{
    MPMediaItem *mediaItem = item;
    return [mediaItem valueForProperty:MPMediaItemPropertyTitle];
}
#pragma mark ------------ property
#pragma mark ------ mediaQuery
- (MPMediaQuery *)mediaQuery{
    if (!_mediaQuery) {
        _mediaQuery = [[MPMediaQuery alloc] init];
    }
    return _mediaQuery;
}
@end
