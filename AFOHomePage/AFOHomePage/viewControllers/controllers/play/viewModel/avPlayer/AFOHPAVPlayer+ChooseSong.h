//
//  AFOHPAVPlayer+ChooseSong.h
//  AFOHomePage
//
//  Created by xueguang xian on 2018/1/23.
//  Copyright © 2018年 AFO. All rights reserved.
//

#import "AFOHPAVPlayer.h"

@interface AFOHPAVPlayer (ChooseSong)
@property (nonatomic, strong) NSNumber       *index;
@property (nonatomic, strong) NSArray        *dataArray;
@property (nonatomic, strong) id              currentItem;
- (void)settingData:(id)model;
- (id)modelFormDataArray;
- (id)modelIndexFromDataArray:(NSInteger)index;
- (void)operationMusicPlayer:(AFOHPAVPlayerSelectMusic)type
                       block:(void (^)(id model))block;
@end
