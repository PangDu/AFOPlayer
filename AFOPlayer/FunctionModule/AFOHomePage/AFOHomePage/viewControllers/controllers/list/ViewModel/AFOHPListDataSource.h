//
//  AFOHPListDataSource.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOHPListDataSource : NSObject<UITableViewDataSource>
- (void)settingDataArray:(NSArray *)array index:(NSInteger)index;
@end
