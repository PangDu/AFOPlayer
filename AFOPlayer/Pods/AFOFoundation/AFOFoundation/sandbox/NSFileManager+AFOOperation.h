//
//  NSFileManager+AFOOperation.h
//  AFOFoundation
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (AFOOperation)
+ (NSString *)createFolderTarget:(NSString *)target
                       newFolder:(NSString *)name;
+ (void)deleteFileFromSandBox:(NSString *)filePath
                        block:(void(^)(BOOL isRemove))block;
@end

NS_ASSUME_NONNULL_END
