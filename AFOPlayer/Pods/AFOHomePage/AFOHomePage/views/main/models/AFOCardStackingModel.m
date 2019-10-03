//
//  AFOCardStackingModel.m
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOCardStackingModel.h"

@interface AFOCardStackingModel ()
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;
@end
@implementation AFOCardStackingModel
- (NSString *)titleIndex:(NSInteger)index{
    return self.titleArray[index];
}
- (NSString *)imageIndex:(NSInteger)index{
    return self.imageArray[index];
}
- (NSDictionary *)dictionaryIndex:(NSInteger)index{
    NSDictionary *dictionary = @{@"value" : [self titleIndex:index],
                                 @"type" : @(index)
                                 };
    return dictionary;
}
#pragma mark ------------ property
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"艺术家",@"专辑",@"所有音乐",@"播放列表"];
    }
    return _titleArray;
}
- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"hp_artist.jpeg",
                        @"hp_albumImage.jpeg",
                        @"hp_allMusic.jpeg",
                        @"hp_list.jpeg"];
    }
    return _imageArray;
}
@end
