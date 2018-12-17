//
//  AFOPLCorresponding.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/9.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFOPLCorrespondingDelegate <NSObject>
@property (nonnull, nonatomic, strong, readonly) dispatch_queue_t queue;
@end
@interface AFOPLCorresponding : NSObject
+ (AFOPLCorresponding *)correspondingDelegate:(id)delegate;
+ (void)createDataBase;
+ (NSArray *)getAllDataFromDataBase;
+ (void)deleteAllDataFromDataBase:(void(^)(BOOL isSucess))block;
+ (void)deleteDataFromDataBase:(NSArray *)array
                            block:(void(^)(BOOL isSucess))block;
- (void)mediathumbnail:(NSArray *)vedioNameArray
                 block:(void (^)(NSArray *array))block;
@end
