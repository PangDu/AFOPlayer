//
//  AFODetailPresenterBusiness.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/9.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFODetailPresenterBusiness : AFOHPPresenter
@property (nonatomic, strong, readonly) NSNumber       *number;
@property (nonatomic, strong, readonly) NSMutableArray *dataArray;
- (void)receiverRouterMessage:(id)model
                        block:(void(^)(NSString *title,
                                                       NSInteger index,
                                                       NSArray *array))block;
@end

NS_ASSUME_NONNULL_END
