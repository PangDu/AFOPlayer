//
//  AFORouterManagerDelegate.h
//  AFORouter
//
//  Created by xueguang xian on 2017/12/25.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol AFORouterManagerDelegate <NSObject>
@optional
- (id)didSenderRouterManagerDelegate;
- (void)didReceiverRouterManagerDelegate:(id)model;
- (void)didReceiverRouterManagerDelegate:(id)model
                              parameters:(NSDictionary *)parameters;
@end
