//
//  AFOMemoryPressure.h
//  AFOPlayer
//
//  系统内存警告时由 AFOAppDelegate 发出，各业务 Pod / 模块可监听以释放缓存。
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 与系统 `UIApplicationDidReceiveMemoryWarningNotification` 同时发布，便于统一业务侧处理。
FOUNDATION_EXPORT NSNotificationName const AFOApplicationDidReceiveMemoryWarningNotification;

NS_ASSUME_NONNULL_END
