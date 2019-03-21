//
//  AFOAppDelegateHook.h
//  AFOAppDelegate
//
//  Created by xueguang xian on 2019/3/15.
//  Copyright © 2019 AFO Science Technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AFOAppDelegateHookDelegate <UIApplicationDelegate>
@end

NS_ASSUME_NONNULL_BEGIN
@interface AFOAppDelegateHook : NSObject<UIApplicationDelegate>
@property(nonatomic, weak) id<AFOAppDelegateHookDelegate>delegate;
@property (nonatomic, strong)   NSMutableArray      *targetArray;
@property (nonatomic, strong)   NSOperationQueue    *queue;
@end

NS_ASSUME_NONNULL_END
