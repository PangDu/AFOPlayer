//
//  AFOPLCorresponding.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/9.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding.h"
#import "AFOPLCorrespondingCategory.h"
@interface AFOPLCorresponding ()
@property (nonatomic, weak) id<AFOPLCorrespondingDelegate>  delegate;
@end

@implementation AFOPLCorresponding
#pragma mark ------------ init
#pragma mark ------ AFOPLCorresponding
+ (AFOPLCorresponding *)correspondingDelegate:(id)delegate{
    AFOPLCorresponding *corresponding = NULL;
    if (delegate != NULL){
        AFOPLCorresponding *temp = [[AFOPLCorresponding alloc] init];
        temp.delegate = delegate;
        corresponding = temp;
    }
    return corresponding;
}
#pragma mark ------------ 创建数据库
- (void)createDataBase{
    [self createDataBaseAndTable];
}
+ (NSArray *)getAllDataFromDataBase{
   return  [self getDataFromDataBase];
}
#pragma mark ------------ 
- (void)mediathumbnail:(NSArray *)vedioNameArray
                 block:(void (^)(NSArray *array,
                                 NSArray *indexArray,
                                 BOOL isUpdate))block{
    [self compareVedioArray:vedioNameArray saveArray:[AFOPLCorresponding getDataFromDataBase] block:^(NSArray *data,
                                                                                        NSArray *indexArray,
                                                      BOOL     isUpdate              ) {
        block(data, indexArray, isUpdate);
    }];
}
#pragma mark ------------
- (void)compareVedioArray:(NSArray *)array
                saveArray:(NSArray *)saveArray
                    block:(void (^) (NSArray *data,
                                     NSArray *indexArray,
                                     BOOL isUpdate))block{
    if (array.count == 0) {//没有视频
        block(NULL, NULL, NO);
        return;
    }else if (array.count > 0 && array.count == saveArray.count){//全部已截图
        block(saveArray, [self indexPathArray:saveArray], NO);
        return;
    }else{//新添加
        [self usedispatchQueue:saveArray array:array block:^(
                                                             NSArray *array,
                                                             NSArray *indexArray,
                                                             BOOL isUpdate) {
            block(array, NULL, isUpdate);
        }];
    }
}
#pragma mark ------
+ (void)deleteDataFromDataBase:(BOOL)isAll
                         block:(void(^)(BOOL isSucess))block{
    [self deleateDataBaseFromSqlLite:isAll block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
#pragma mark ------ 属性
@end
