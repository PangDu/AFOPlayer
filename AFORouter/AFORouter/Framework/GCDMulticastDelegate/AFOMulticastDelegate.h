//
//  AFOMulticastDelegate.h
//  AFORouter
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AFORouterMulticastDelegate;
@class GCDMulticastDelegate;
@interface AFOMulticastDelegate : NSObject
@property (nonatomic, strong, readonly)   GCDMulticastDelegate<AFORouterMulticastDelegate> *multicastDelegate;
+ (instancetype)shareInstance;
- (instancetype)init;
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)queue;
- (void)addDelegate:(id)delegate
      delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate
         delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate;

- (void)interfacialTransferValue;
@end

@protocol AFORouterMulticastDelegate <NSObject>
@optional
- (id)didSenderControllerRouterMulticastDelegate;
- (void)didReceiverControllerRouterMulticastDelegate:(id)model;
@end
