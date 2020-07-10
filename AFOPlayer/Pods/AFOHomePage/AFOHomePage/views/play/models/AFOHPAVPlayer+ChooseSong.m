//
//  AFOHPAVPlayer+ChooseSong.m
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/23.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPAVPlayer+ChooseSong.h"
#import <objc/runtime.h>
@interface AFOHPAVPlayer ()
@end

@implementation AFOHPAVPlayer (ChooseSong)

#pragma mark ------------- property
- (void)setDataArray:(NSArray *)dataArray{
    objc_setAssociatedObject(self, @selector(setDataArray:), dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray *)dataArray{
    return  objc_getAssociatedObject(self, @selector(setDataArray:));
}
- (void)setIndex:(NSNumber *)index{
    objc_setAssociatedObject(self, @selector(setIndex:), index, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)index{
    return  objc_getAssociatedObject(self, @selector(setIndex:));
}
- (void)setCurrentItem:(id)currentItem{
    objc_setAssociatedObject(self, @selector(setCurrentItem:), currentItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)currentItem{
    return  objc_getAssociatedObject(self, @selector(setCurrentItem:));
}
#pragma mark ------
- (void)settingData:(id)model{
    NSDictionary *dictionary = model;
    self.index = dictionary[@"index"];
    self.dataArray = [[NSArray alloc] initWithArray:dictionary[@"data"]];
}
#pragma mark ------
- (id)modelFormDataArray{
    return [self.dataArray objectAtIndex:[self.index integerValue]];
}
#pragma mark ------
- (id)modelIndexFromDataArray:(NSInteger)index{
    return self.dataArray[index];
}
#pragma mark ------------ 选择播放
- (void)operationMusicPlayer:(AFOHPAVPlayerSelectMusic)type
                       block:(void (^)(id model))block{
    ///------
    NSInteger select = [self.index integerValue];
    switch (type) {
        case AFOHPAVPlayerSelectMusicOn:
            select -= 1;
            break;
        default:
            select +=1;
            break;
    }
    ///------
    NSInteger count = self.dataArray.count - 1;
    if (select >= 0) {
        if (select <= count) {
            self.index = @(select);
            block(self.dataArray[select]);
        }else{
            select -= 1;
            self.index = @(select);
            block(NULL);
        }
    }
}
@end
