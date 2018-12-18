//
//  AFOPLCorresponding+NSOperationQueue.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding+NSOperationQueue.h"
@implementation AFOPLCorresponding (NSOperationQueue)
#pragma marm ------------ property
- (void)setOperationQueue:(NSOperationQueue *)operationQueue{
    objc_setAssociatedObject(self, @selector(setOperationQueue:), operationQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSOperationQueue *)operationQueue{
    return objc_getAssociatedObject(self, @selector(setOperationQueue:));
}
#pragma mark ------------ NSOperationQueue
- (void)useOperationQueue:(NSArray *)saveArray
                    array:(NSArray *)array
                    block:(void (^) (NSArray * array))block{
    NSArray *addArray = [AFOPLCorresponding getUnscreenshotsArray:array compare:saveArray];
    NSBlockOperation *opreration = [NSBlockOperation blockOperationWithBlock:^{
        [[AFOMediaForeignInterface shareInstance] mediaSeekFrameUseQueue:addArray vediopath:[NSFileManager documentSandbox] imagePath:[AFOPLMainFolderManager mediaImagesAddress] sqlite:[AFOPLMainFolderManager dataBaseAddress] block:^(BOOL isHave,NSString *createTime,NSString *vedioName, NSString *imageName, int width, int height) {
            [AFOPLSQLiteManager inserSQLiteDataBase:AFO_PLAYLIST_SCREENSHOTSVEDIOLIST isHave:isHave createTime:createTime vedioName:vedioName imageName:imageName width:width height:height block:^(BOOL isFinish) {
                if (isFinish) {
                    NSLog(@"成功插入数据!");
                }
            }];
        }];
    }];
    ///------
    NSBlockOperation *operationR = [NSBlockOperation blockOperationWithBlock:^{
        NSArray *array = [AFOPLCorresponding getDataFromDataBase];
        block(array);
    }];
    [operationR addDependency:opreration];
    [self.operationQueue addOperation:opreration];
    [self.operationQueue addOperation:operationR];
}
@end
