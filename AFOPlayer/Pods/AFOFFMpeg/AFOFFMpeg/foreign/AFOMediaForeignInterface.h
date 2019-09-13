//
//  AFOMediaForeignInterface.h
//  AFOMediaPlay
//
//  Created by xueguang xian on 2018/1/6.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//


/**
 <#Description#>

 @param isHave <#isHave description#>
 @param createTime <#createTime description#>
 @param vedioName <#vedioName description#>
 @param imageName <#imageName description#>
 @param width <#width description#>
 @param height <#height description#>
 */
typedef void(^mediaSeekFrameQueueBlock)(BOOL isHave,
                                        
                                        NSString *createTime,
                                        
                                        NSString *vedioName,
                                        
                                        NSString *imageName,
                                        
                                        int width,
                                        
                                        int height
                                        );
@interface AFOMediaForeignInterface : NSObject
/**
 <#Description#>

 @return <#return value description#>
 */
+ (instancetype)shareInstance;

/**
 <#Description#>

 @param model <#model description#>
 @param path <#path description#>
 @param imagePath <#imagePath description#>
 @param sqlitePath <#sqlitePath description#>
 @param block <#block description#>
 */
- (void)mediaSeekFrameUseQueue:(id)model
                     vediopath:(NSString *)path
                     imagePath:(NSString *)imagePath
                        sqlite:(NSString *)sqlitePath
                         block:(mediaSeekFrameQueueBlock)block;


@end
