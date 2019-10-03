//
//  AFOFMDBForeignInterface+Dictionary.h
//  AFOSQLite
//
//  Created by xueguang xian on 2018/1/14.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import <AFOSQLite/AFOSQLite.h>

@interface AFOFMDBForeignInterface (Dictionary)
+ (id)dictinaryToClassModel:(NSDictionary *)dictionary
                        model:(id)model;
@end
