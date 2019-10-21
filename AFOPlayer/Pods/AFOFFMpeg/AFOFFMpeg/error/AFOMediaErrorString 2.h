//
//  AFOMediaErrorString.h
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/31.
//  Copyright © 2017年 AFO. All rights reserved.
//

#ifndef AFOMediaErrorString_h
#define AFOMediaErrorString_h

typedef NS_ENUM(NSInteger, AFOPlayMediaErrorCode) {
    
    AFOPlayMediaErrorNone                                 = 0 ,
    
    AFOPlayMediaErrorCodeReadFailure                      = 1 ,
    
    AFOPlayMediaErrorCodeVideoStreamFailure               = 2 ,
    
    AFOPlayMediaErrorCodeNoneDecoderFailure               = 3 ,
    
    AFOPlayMediaErrorCodeOpenDecoderFailure               = 4 ,
    
    AFOPlayMediaErrorCodeDecoderImageFailure              = 5 ,
    
    AFOPlayMediaErrorCodeAllocateCodecContextFailure      = 6 ,
    
    AFOPlayMediaErrorCodeImageorFormatConversionFailure   = 7 ,
    
    AFOPlayMediaErrorCodeRetrieveStreamInformationFailure = 8
};
///------ AFOPlayMediaErrorNone
static const NSString *AFOMeidaFaileNone          = @"成功!";

///------ AFOPlayMediaErrorCodeReadFailure
static const NSString *AFOMeidaFailedReadFile     = @"读取文件,失败!";

///------ AFOPlayMediaErrorCodeVideoStreamFailure
static const NSString *AFOMeidaVideoStreamFailure = @"获取音视频及字幕的stream_index,失败!";

///------ AFOPlayMediaErrorCodeNoneDecoderFailure
static const NSString *AFOMeidaNoneDecoderFailure = @"查找解码器,失败!";

///------ AFOPlayMediaErrorCodeOpenDecoderFailure
static const NSString *AFOPlayMediaOpenDecoderFailure = @"打开解码器,失败!";

///------ AFOPlayMediaErrorCodeDecoderImageFailure
static const NSString *AFOPlayMediaDecoderImageFailure = @"AVFrame中data为空";

///------ AFOPlayMediaErrorCodeAllocateCodecContextFailure
static const NSString *AFOPlayMediaAllocateCodecContextFailure = @"初始化AVCodecContext,失败!";

///------ AFOPlayMediaErrorCodeImageorFormatConversionFailure
static const NSString *AFOPlayMediaImageorFormatConversionFailure = @"初始化SwsContext,失败!";
///------ AFOPlayMediaErrorCodeRetrieveStreamInformationFailure
static const NSString *AFOPlayMediaRetrieveStreamInformationFailure = @"检索流失败";
typedef NS_ENUM(NSInteger, AFOAVMediaTypeErrorCode) {
    AFOAVMEDIATYPEUNKNOWN = -1,    ///< Usually treated as AVMEDIA_TYPE_DATA
    AFOAVMEDIATYPEVIDEOErrorCode,
    AFOAVMEDIATYPEAUDIOErrorCode,
    AFOAVMEDIATYPEDATAErrorCode,          ///< Opaque data information usually continuous
    AFOAVMEDIATYPESUBTITLEErrorCode,
    AFOAVMEDIATYPEATTACHMENTErrorCode,    ///< Opaque data information usually sparse
    AFOAVMEDIATYPENBErrorCode
};
///------
///------
///------
#endif /* AFOMediaErrorString_h */
