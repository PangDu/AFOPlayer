//
//  AFOAppCompositionRoot.h
//  AFOPlayer
//
//  应用级装配（MVVM 迁移 P2）：集中创建 Tab 与模块根控制器，减轻 AppDelegate 职责。
//

#import <UIKit/UIKit.h>

@class AFOAppTabBarController;

NS_ASSUME_NONNULL_BEGIN

@interface AFOAppCompositionRoot : NSObject

+ (AFOAppTabBarController *)makeRootTabBarController;

@end

NS_ASSUME_NONNULL_END
