//
//  AFOHPDetailController+Router.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/17.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPDetailController.h"

@interface AFOHPDetailController (Router)
@property (nonatomic, strong) NSMutableArray           *hpDetailArray;
@property (nonatomic, strong) NSNumber                 *selectNumber;
- (void)tableViewdidSelectRowAtIndexPathExchange;
@end
