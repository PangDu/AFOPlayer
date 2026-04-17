//
//  AFOPLPlaylistRoutingDataSource.h
//  AFOPlaylist
//
//  列表项路由所需数据（由 AFOPLMainManager 实现，单测可提供桩对象）。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFOPLPlaylistRoutingDataSource <NSObject>

- (NSString *)vedioAddressIndexPath:(NSIndexPath *)indexPath;
- (NSString *)vedioNameIndexPath:(NSIndexPath *)indexPath;
- (UIInterfaceOrientationMask)orientationMask:(NSIndexPath *)indexPath;

@optional

/// 当前列表条目数（用于编辑菜单、ViewModel 状态同步）。
- (NSUInteger)playlistItemCount;

/// 缩略图模型快照（全选等，避免在 VC 上再挂一份数组）。
- (NSArray *)playlistThumbnailItemsSnapshot;

@end

NS_ASSUME_NONNULL_END
