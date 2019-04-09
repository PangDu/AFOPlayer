//
//  AFOListPresenterBusiness.h
//  AFOHomePage
//
//  Created by xueguang xian on 2019/4/8.
//  Copyright © 2019 AFO. All rights reserved.
//

#import "AFOHPPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFOListPresenterBusiness : AFOHPPresenter<UITableViewDelegate>
- (void)receiverRouterMessage:(id)model block:(void(^)(NSString *title,
                                                       NSInteger index,
                                                       NSArray *array))block;
@end

NS_ASSUME_NONNULL_END
