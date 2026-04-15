//
//  AFOPLMainListViewModel.h
//  AFOPlaylist
//

#import <Foundation/Foundation.h>
#import "AFOPLPlaylistRoutingDataSource.h"

@class AFOPLMainManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFOPLMainListViewModel : NSObject

@property (nonatomic, strong, readonly) id<AFOPLPlaylistRoutingDataSource> routingDataSource;

/// 列表条目数（轻量状态输出）。
@property (nonatomic, assign, readonly) NSUInteger itemCount;

/// 默认调用 `AFORoutingPerformWithParameters`；单元测试可赋值以捕获参数、避免真实跳转。
@property (nonatomic, copy, nullable) void (^routePerformBlock)(NSDictionary *parameters);

/// `itemCount` 变化时回调（主线程调用由调用方保证）。
@property (nonatomic, copy, nullable) void (^onListStateChange)(NSUInteger itemCount);

- (instancetype)initWithRoutingDataSource:(id<AFOPLPlaylistRoutingDataSource>)dataSource;

/// 等价于 `initWithRoutingDataSource:`。
- (instancetype)initWithMainManager:(nullable AFOPLMainManager *)mainManager;

- (void)openPlayerAtIndexPath:(NSIndexPath *)indexPath currentControllerClassName:(NSString *)currentClassName;

/// 在 `getThumbnailData` 完成并刷新 UI 数据源后调用，同步 `itemCount`。
- (void)syncListStateAfterReload;

@end

NS_ASSUME_NONNULL_END
