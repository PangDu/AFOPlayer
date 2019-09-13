//
//  KxMovieSubtitleASSParser.h
//  AFOFFMpeg
//
//  Created by xueguang xian on 2018/12/9.
//  Copyright © 2018 AFO Science and technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KxMovieSubtitleASSParser : NSObject
+ (NSArray *) parseEvents: (NSString *) events;
+ (NSArray *) parseDialogue: (NSString *) dialogue
                  numFields: (NSUInteger) numFields;
+ (NSString *) removeCommandsFromEventText: (NSString *) text;
@end

NS_ASSUME_NONNULL_END
