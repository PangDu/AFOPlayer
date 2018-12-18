//
//  AFOMediaForeignInterface.m
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/6.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOMediaForeignInterface.h"
#import "AFOMediaSeekFrame.h"

@interface AFOMediaForeignInterface ()
@property (nonnull, nonatomic, strong) NSMutableArray        *seekArray;
@property (nonnull, nonatomic, strong) dispatch_queue_t       queue_t;
@end

@implementation AFOMediaForeignInterface

#pragma mark ------------ shareInstance
+ (instancetype)shareInstance{
    static AFOMediaForeignInterface *shareInstance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        shareInstance = [ [self alloc] init];
    });
    return shareInstance;
}
#pragma mark ------------
- (void)mediaSeekFrameUseQueue:(id)model
                     vediopath:(NSString *)path
                     imagePath:(NSString *)imagePath
                         sqlite:(NSString *)sqlitePath
                         block:(mediaSeekFrameQueueBlock)block{
    if ([model isKindOfClass:[NSArray class]]) {
        NSArray *vedioArray = model;
        [self getSeekFrame:vedioArray vediopath:path imagePath:imagePath sqlite:sqlitePath block:^(BOOL isHave, NSString *createTime,NSString *vedioName, NSString *imageName, int width, int height) {
            block(isHave, createTime, vedioName, imageName, width, height);
        }];
    }else{
        [AFOMediaSeekFrame vedioName:model path:path imagePath:imagePath plist:sqlitePath block:^(BOOL isWrite, BOOL isCutting, NSString *createTime, NSString *vedioName, NSString *imageName, int width, int height) {
            block(isWrite, createTime, vedioName, imageName, width, height);
        }];
    }
}
#pragma mark ------
- (void)getSeekFrame:(NSArray *)vedioArray
           vediopath:(NSString *)vediopath
           imagePath:(NSString *)imagePath
               sqlite:(NSString *)sqlitePath
               block:(mediaSeekFrameQueueBlock)block{
    dispatch_apply(vedioArray.count, self.queue_t, ^(size_t index) {
        dispatch_async(self.queue_t, ^{
            [AFOMediaSeekFrame vedioName:vedioArray[index] path:vediopath imagePath:imagePath plist:sqlitePath block:^(BOOL isWrite,
                                                                                                         BOOL isCutting,
                                                                                                         
                                                                                                         NSString *createTime,
                                                                                                         NSString *vedioName,
                                                                                                         NSString *imageName,
                                                                                                         int width,
                                                                                                         int height) {
                block(isWrite, createTime, vedioName, imageName, width, height);
            }];
        });
    });
}
#pragma mark ------------ property
- (NSMutableArray *)seekArray{
    if (!_seekArray) {
        _seekArray = [[NSMutableArray alloc] init];
    }
    return _seekArray;
}
- (dispatch_queue_t)queue_t{
    if (!_queue_t) {
        _queue_t = dispatch_queue_create("com.AFOFFMpeg.AFOMediaForeignInterface", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue_t;
}
@end
