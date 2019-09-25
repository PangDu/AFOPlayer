//
//  AFOCardStackingModel.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/20.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOCardStackingModel : NSObject
- (NSString *)titleIndex:(NSInteger)index;
- (NSString *)imageIndex:(NSInteger)index;
- (NSDictionary *)dictionaryIndex:(NSInteger)index;
@end
