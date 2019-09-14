//
//  AFOReadDirectoryFile.h
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/4.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFOReadDirectoryFileDelegate <NSObject>
@required
- (void)directoryFromDocument:(NSArray *)array;
@end

@interface AFOReadDirectoryFile : NSObject
+ (AFOReadDirectoryFile *)readDirectoryFiledelegate:(id)directoryDelegate;
@end
