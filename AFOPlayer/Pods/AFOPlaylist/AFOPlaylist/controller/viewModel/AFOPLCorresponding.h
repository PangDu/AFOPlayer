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
+ (AFOPLCorresponding *_Nullable)correspondingDelegate:(id _Nullable )delegate;
+ (void)createDataBase;
+ (NSArray *_Nullable)getAllDataFromDataBase;
+ (void)deleteAllDataFromDataBase:(void(^_Nullable)(BOOL isSucess))block;
+ (void)deleteDataFromDataBase:(NSArray *_Nullable)array
                         block:(void(^_Nullable)(BOOL isSucess))block;
@end
