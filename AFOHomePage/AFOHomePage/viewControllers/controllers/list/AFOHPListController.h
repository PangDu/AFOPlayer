//
//  AFOHPListController.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/18.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFOUIKit/AFOUIKit.h>
@class AFOHPListViewModel;
@interface AFOHPListController : AFOViewController
@property (nonatomic, strong, readonly) AFOHPListViewModel      *viewModel;
@end
