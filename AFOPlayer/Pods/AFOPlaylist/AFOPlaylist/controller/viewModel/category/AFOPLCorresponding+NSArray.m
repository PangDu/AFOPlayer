//
//  AFOPLCorresponding+NSArray.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/15.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+NSArray.h"
#import <AFOFoundation/AFOFoundation.h>
#import "AFOPLThumbnail.h"
@implementation AFOPLCorresponding (NSArray)
+ (NSArray *)getUnscreenshotsArray:(NSArray *)data
                      compare:(NSArray *)compare{
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",compare];
    //过滤数组
    NSArray *reslut = [data filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"Reslut Filtered Array = %@",reslut);
    return reslut;
}
+ (NSArray *)vedioName:(NSArray *)data{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFOPLThumbnail *model = obj;
        [array addObjectAFOAbnormal:model.vedio_name];
    }];
    return array;
}
#pragma mark ------------
+ (NSArray<NSIndexPath *> *)indexPathArray:(NSArray *)array
                                     index:(NSInteger)index{
    __block NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > index) {
                [indexArray addObjectAFOAbnormal:[NSIndexPath indexPathForItem:idx inSection:0]];
            }
    }];
    return indexArray;
}
+ (NSArray<NSIndexPath *> *)indexPathArray:(NSArray *)array{
    __block NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [indexArray addObjectAFOAbnormal:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    return indexArray;
}
@end
