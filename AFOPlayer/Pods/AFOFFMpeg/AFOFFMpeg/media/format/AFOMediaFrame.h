//
//  AFOMediaFrame.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/2/2.
//  Copyright © 2018年 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AFOMediaFrameType) {
    
    AFOMediaFrameTypeAudio       =   0,
    
    AFOMediaFrameTypeVideo       =   1,
    
    AFOMediaFrameTypeArtwork     =   2,
    
    AFOMediaFrameTypeSubtitle    =   3
    
};

@interface AFOMediaFrame : NSObject
@end
