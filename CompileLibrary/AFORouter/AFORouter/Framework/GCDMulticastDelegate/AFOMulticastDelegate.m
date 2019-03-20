//
//  AFOMulticastDelegate.m
//  AFORouter
//
//  Created by xueguang xian on 2018/1/18.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOMulticastDelegate.h"
#import "GCDMulticastDelegate.h"

@interface AFOMulticastDelegate (){
    void *moduleQueueTag;
}
@property (nonatomic, strong)        dispatch_queue_t  moduleQueue;
@property (nonatomic, strong, readwrite)       GCDMulticastDelegate<AFORouterMulticastDelegate>  *multicastDelegate;
@end

@implementation AFOMulticastDelegate
#pragma mark ------------ shareInstance
+ (instancetype)shareInstance{
    static AFOMulticastDelegate *shareInstance;
    static dispatch_once_t  once_t;
    dispatch_once(&once_t, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
#pragma mark ------------ init
- (instancetype)init{
    return [self initWithDispatchQueue:dispatch_get_main_queue()];
}
#pragma mark ------------ initWithDispatchQueue
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)queue{
    if (self = [super init]) {
        if (queue != dispatch_get_main_queue()) {
            const char *moduleQueueName = [NSStringFromClass([self class]) UTF8String];
            _moduleQueue = dispatch_queue_create(moduleQueueName, NULL);
            moduleQueueTag = &moduleQueueTag;
            dispatch_queue_set_specific(_moduleQueue, moduleQueueTag, moduleQueueTag, NULL);
        }else{
            _moduleQueue = queue;
        }
    }
    return self;
}
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    dispatch_block_t block = ^{
        [self.multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    };
    ///-------
    if (dispatch_get_specific(moduleQueueTag)){
        block();
    }else{
        dispatch_async(self.moduleQueue, block);
    }
}
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue synchronously:(BOOL)synchronously{
    dispatch_block_t block = ^{
        [self.multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    };
    ///-------
    if (dispatch_get_specific(moduleQueueTag)){
        block();
    }else if (synchronously){
        dispatch_sync(self.moduleQueue, block);
    }else{
        dispatch_async(self.moduleQueue, block);
    }
}
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue{
    [self removeDelegate:delegate delegateQueue:delegateQueue synchronously:YES];
}
- (void)removeDelegate:(id)delegate{
    [self removeDelegate:delegate delegateQueue:NULL synchronously:YES];
}

- (void)interfacialTransferValue{
    [[AFOMulticastDelegate shareInstance].multicastDelegate didReceiverControllerRouterMulticastDelegate:@"ddddd"];
}
#pragma mark ------------ property
#pragma mark ------ moduleQueue
- (dispatch_queue_t)moduleQueue{
    return _moduleQueue;
}
#pragma mark ------ multicastDelegate
- (GCDMulticastDelegate *)multicastDelegate{
    if (_multicastDelegate) {
        _multicastDelegate = (GCDMulticastDelegate<AFORouterMulticastDelegate> *)[[GCDMulticastDelegate alloc] init];
    }
    return _multicastDelegate;
}
@end
