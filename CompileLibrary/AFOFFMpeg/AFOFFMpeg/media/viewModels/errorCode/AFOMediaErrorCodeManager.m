//
//  AFOMediaErrorCodeManage.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/30.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOMediaErrorCodeManager.h"


static NSDictionary *codeDictionary;
@interface AFOMediaErrorCodeManager ()
@end
@implementation AFOMediaErrorCodeManager
#pragma mark ------ initialize
+ (void)initialize{
    if (self == [AFOMediaErrorCodeManager class]) {
        codeDictionary = @{@(AFOPlayMediaErrorNone): AFOMeidaFaileNone,
                           
                           @(AFOPlayMediaErrorCodeReadFailure) : AFOMeidaFailedReadFile,
                           @(AFOPlayMediaErrorCodeVideoStreamFailure) :
                               AFOMeidaVideoStreamFailure,
                           @(AFOPlayMediaErrorCodeNoneDecoderFailure) :
                               AFOMeidaNoneDecoderFailure,
                           @(AFOPlayMediaErrorCodeOpenDecoderFailure) :
                               AFOPlayMediaOpenDecoderFailure,
                           @(AFOPlayMediaErrorCodeDecoderImageFailure):
                               AFOPlayMediaDecoderImageFailure,
                           @(AFOPlayMediaErrorCodeAllocateCodecContextFailure) :
                               AFOPlayMediaAllocateCodecContextFailure,
                           @(AFOPlayMediaErrorCodeImageorFormatConversionFailure) : AFOPlayMediaImageorFormatConversionFailure,
                           @(AFOPlayMediaErrorCodeRetrieveStreamInformationFailure):
                               AFOPlayMediaRetrieveStreamInformationFailure
                           };
    }
}
#pragma mark ------ 根据errorCode返回Error
+ (NSError *)errorCode:(AFOPlayMediaErrorCode)errorCode{
    NSError *error = [NSError errorWithDomain:codeDictionary[@(errorCode)] code:errorCode userInfo:codeDictionary];
    return error;
}
#pragma mark ------------ property
@end
