//
//  AFOAddControllerModel.h
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/13.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFOAppTabBarController;

/// Tab 根控制器需实现此方法（建议在业务类上声明遵循本协议，便于静态检查）。
@protocol AFOTabRootControllerProviding <NSObject>
- (UIViewController *)returnController;
@end

@interface AFOAddControllerModel : NSObject

/// 根据 `controllerArray` 中的类名实例化 Tab 子控制器并赋值给 `tabBarController`。
- (void)controllerInitialization:(AFOAppTabBarController *)tabBarController;

@end
