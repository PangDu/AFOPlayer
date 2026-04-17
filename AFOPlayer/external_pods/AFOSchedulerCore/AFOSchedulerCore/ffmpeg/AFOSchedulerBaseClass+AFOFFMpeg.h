//
//  AFOSchedulerBaseClass+AFOFFMpeg.h
//  AFOSchedulerCore
//
//  Created by piccolo on 2019/10/14.
//  Copyright © 2019 piccolo. All rights reserved.
//
#import <AFOSchedulerCore/AFOSchedulerBaseClass.h>

static const NSString * _Nullable mediaPlayReceiverParametersSelector = @"mediaPlayReceiverParameters";
NS_ASSUME_NONNULL_BEGIN

@interface AFOSchedulerBaseClass (AFOFFMpeg)
+ (void)schedulerMediaPlayReceiverParameters:(id)parameter;
@end

NS_ASSUME_NONNULL_END
