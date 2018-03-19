//
//  AFOPLCorresponding+SQLite.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/16.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOPLCorresponding.h"

@interface AFOPLCorresponding (SQLite)
- (void)createDataBaseAndTable;
- (NSArray *)getDataFromDataBase;
@end
