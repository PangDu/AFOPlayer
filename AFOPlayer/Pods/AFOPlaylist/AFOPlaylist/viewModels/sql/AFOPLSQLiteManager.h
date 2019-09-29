//
//  AFOPlaylistSQLiteManager.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/12.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOPLSQLiteManager : NSObject

/**
 <#Description#>
 
 @param name <#name description#>
 @return <#return value description#>
 */
+ (NSString *)createTable:(NSString *)name;

/**
 <#Description#>

 @param dataBase <#dataBase description#>
 @param path <#path description#>
 @param block <#block description#>
 */
+ (void)createSQLiteDataBase:(NSString *)dataBase
                        path:(NSString *)path
                       block:(void (^)(BOOL isFinish))block;



/**
 <#Description#>

 @param dataBase <#dataBase description#>
 @param isHave <#isHave description#>
 @param vedioName <#vedioName description#>
 @param imageName <#imageName description#>
 @param width <#width description#>
 @param height <#height description#>
 @param block <#block description#>
 */
+ (void)inserSQLiteDataBase:(NSString *)dataBase
                     isHave:(BOOL)isHave
                 createTime:(NSString *)createTime
                  vedioName:(NSString *)vedioName
                  imageName:(NSString *)imageName
                      width:(int)width
                      height:(int)height
                      block:(void (^) (BOOL isFinish))block;



/**
 <#Description#>

 @param dataBase <#dataBase description#>
 @param block <#block description#>
 */
+ (void)selectSQLiteDataBase:(NSString *)dataBase
                       block:(void (^) (NSArray *array))block;


/**
 <#Description#>

 @param dataBase <#dataBase description#>
 @param block <#block description#>
 */
+ (void)deleateAllDataBase:(NSString *)dataBase
                  block:(void(^)(BOOL isSucess))block;
+ (void)deleateDataBase:(NSString *)dataBase
                   data:(NSArray *)array
                     block:(void(^)(BOOL isSucess))block;
@end
