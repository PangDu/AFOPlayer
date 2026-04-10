//
//  AFOPLMainController+Operation.h
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController.h"
#import "AFOPLMainEditorLogic.h" // 引入新的逻辑处理类

NS_ASSUME_NONNULL_BEGIN

@interface AFOPLMainController (Operation)

@property (nonnull, nonatomic, strong) AFOPLMainEditorLogic *editorLogic;

@end

NS_ASSUME_NONNULL_END
