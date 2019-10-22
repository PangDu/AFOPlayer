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
+ (void)createDataBase{
    [AFOPLCorresponding createDataBaseAndTable];
}
+ (NSArray *)getAllDataFromDataBase{
   return [self getDataFromDataBase];
}
#pragma mark ------
+ (void)deleteAllDataFromDataBase:(void(^)(BOOL isSucess))block{
    [self deleateAllDataBaseFromSqlLite:^(BOOL isSucess) {
        block(isSucess);
    }];
}
+ (void)deleteDataFromDataBase:(NSArray *)array
                         block:(void(^)(BOOL isSucess))block{
    [self deleateDataBaseFromSqlLite:array block:^(BOOL isSucess) {
        block(isSucess);
    }];
}
#pragma mark ------ dealloc
- (void)dealloc{
    NSLog(@"AFOPLCorresponding dealloc");
}
@end
