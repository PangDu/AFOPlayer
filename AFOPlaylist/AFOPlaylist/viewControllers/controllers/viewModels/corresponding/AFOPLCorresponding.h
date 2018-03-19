//
//  AFOPLCorresponding.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/9.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFOPLCorrespondingDelegate <NSObject>
@end

@interface AFOPLCorresponding : NSObject
+ (AFOPLCorresponding *)correspondingDelegate:(id)delegate;
- (void)createDataBase;
- (void)mediathumbnail:(NSArray *)vedioNameArray
                 block:(void (^)(NSArray *array,
                                 NSArray *indexArray,
                                 BOOL isUpdate))block;
@end
