//
//  AFOPLMainController+Operation.m
//  AFOPlaylist
//
//  Created by xueguang xian on 2018/12/12.
//  Copyright © 2018 AFO. All rights reserved.
//

#import "AFOPLMainController+Operation.h"
#import <objc/runtime.h>

@implementation AFOPLMainController (Operation)

#pragma mark - Accessors

- (void)setEditorLogic:(AFOPLMainEditorLogic *)editorLogic {
    objc_setAssociatedObject(self, @selector(editorLogic), editorLogic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AFOPLMainEditorLogic *)editorLogic {
    AFOPLMainEditorLogic *logic = objc_getAssociatedObject(self, @selector(editorLogic));
    if (!logic) {
        logic = [[AFOPLMainEditorLogic alloc] initWithMainController:self];
        self.editorLogic = logic;
    }
    return logic;
}

@end
