//
//  AFOFMDBForeignInterface.h
//  AFOFMDB
//
//  Created by xueguang xian on 2018/1/11.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOFMDBForeignInterface : NSObject
+ (void)createSQLiteTable:(NSString *)table
                     path:(NSString *)path
               statements:(NSString *)statements
                    block:(void (^)(BOOL isSucessed))block;
+ (void)insertSQLiteTableStatements:(NSString *)statements
                    block:(void (^)(BOOL isSucessed))block;
+ (void)selectSQLiteTableStatements:(NSString *)statements
                              model:(id)model
                              block:(void (^)(NSArray *array))block;
+ (void)deleteSQLiteTableStatements:(NSString *)statements
                              block:(void (^)(BOOL isSucess))block;
+ (void)deleteTransactionStatements:(NSArray<NSString *> *)array
                              block:(void (^)(BOOL isSucess))block;
@end
