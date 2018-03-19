//
//  AFOPLThumbnail.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/1/15.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFOPLThumbnail : NSObject
@property (nonatomic, copy) NSString   *create_time;
@property (nonatomic, copy) NSString   *vedio_name;
@property (nonatomic, copy) NSString   *image_name;
@property (nonatomic, assign) NSInteger vedio_id;
@property (nonatomic, assign) NSInteger image_width;
@property (nonatomic, assign) NSInteger image_hight;
@end
