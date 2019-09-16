//
//  AFOGenerateImages.h
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/30.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOFFMpegHeader.h"
/**
 <#Description#>

 @param error <#error description#>
 @param context <#context description#>
 */
typedef void(^generateSwsContextBlock)(struct SwsContext *context, NSError *error);

/**
 <#Description#>

 @param image <#image description#>
 @param error <#error description#>
 */
typedef void(^generateImageBlock)(UIImage *image, NSError *error);

/**
 <#Description#>

 @param frame <#frame description#>
 */
typedef void(^avframeWithContextBlock)(struct AVFrame *frame, uint8_t *buffer);

@interface AFOGenerateImages : NSObject

/**
 <#Description#>

 @param avFrame <#avFrame description#>
 @param avCodecContext <#avCodecContext description#>
 @param outSize <#outSize description#>
 @param srcFormat <#srcFormat description#>
 @param dstFormat <#dstFormat description#>
 @param format <#format description#>
 @param component <#component description#>
 @param pixel <#pixel description#>
 @param block <#block description#>
 */
- (void)decodingImageWithAVFrame:(struct AVFrame *)avFrame
                    codecContext:(AVCodecContext *)avCodecContext
                         outSize:(CGSize)outSize
                       srcFormat:(enum AVPixelFormat)srcFormat
                       dstFormat:(enum AVPixelFormat)dstFormat
                     pixelFormat:(enum AVPixelFormat)format
                bitsPerComponent:(size_t)component
                    bitsPerPixel:(size_t)pixel
                           block:(generateImageBlock)block;

/**
 <#Description#>

 @param avFrame <#avFrame description#>
 @param outSize <#outSize description#>
 @param block <#block description#>
 */
- (void)decoedImageForYUV:(struct AVFrame *)avFrame
                  outSize:(CGSize)outSize
                    block:(generateImageBlock)block;
@end
