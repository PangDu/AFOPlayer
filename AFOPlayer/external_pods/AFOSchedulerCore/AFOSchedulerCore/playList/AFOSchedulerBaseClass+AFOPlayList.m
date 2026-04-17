//
//  AFOSchedulerBaseClass+AFOPlayList.m
//  AFOSchedulerCore
//
//  Created by piccolo on 2019/10/14.
//  Copyright © 2019 piccolo. All rights reserved.
//

#import "AFOSchedulerBaseClass+AFOPlayList.h"

@implementation AFOSchedulerBaseClass (AFOPlayList)
+ (void)schedulerPlayListPassDictionary:(NSDictionary *)dictionary{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AFO_MEDIAPLAY_RECEIVERPARAMETERS_NOTIFICATION" object:dictionary];
}
@end
