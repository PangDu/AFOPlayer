//
//  NSFileManager+AFOSandBox.h
//  AFOFoundation
//
//  Created by xueguang xian on 2018/1/25.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (AFOSandBox)
+ (NSString *)createFolderTarget:(NSString *)target
                       newFolder:(NSString *)name;
+ (NSString *)documentSandbox;
+ (NSString *)cachesDocumentSandbox;
@end
