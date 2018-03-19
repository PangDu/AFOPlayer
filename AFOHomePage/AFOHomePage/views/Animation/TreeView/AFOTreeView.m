//
//  AFOTreeView.m
//  AFOPlayer
//
//  Created by xueguang xian on 2017/12/15.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import "AFOTreeView.h"
#import "AFOTreeViewCenter.h"
#import "AFOTreeViewAround.h"
#import "AFOTreeViewLayout.h"

@interface AFOTreeView ()
@property (nonatomic, strong) AFOTreeViewCenter  *centerView;
@property (nonatomic, strong) AFOTreeViewLayout  *layout;
@end

@implementation AFOTreeView

- (instancetype)initWithFrame:(CGRect)frame withLayout:(id)layout{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self settingViewWithLayout:layout];
    }
    return self;
}
- (void)settingViewWithLayout:(AFOTreeViewLayout *)layout{
    //------ centerView
    self.centerView.frame =CGRectMake(0, 0, 1.5*layout.aroundWidth, 1.5*layout.aroundWidth);
    self.centerView.backgroundColor = [UIColor yellowColor];
    self.centerView.center = self.center;
    [self addSubview:self.centerView];
    //------ aroundView
    @autoreleasepool{
        NSInteger factor = 1;
        for (int i = 0; i <layout.titleArray.count; i++) {
            AFOTreeViewAround *around = [[AFOTreeViewAround alloc]initWithFrame:CGRectMake(0, 0, layout.aroundWidth, layout.aroundWidth)];
            around.backgroundColor = [UIColor redColor];
            around.tag = i + 1000;
            [self.layout settingAroundView:around treeView:self layout:layout index:factor];
            factor += 2;
            [self addSubview:around];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark ------------ 属性
#pragma mark ------ centerView
- (AFOTreeViewCenter *)centerView{
    if (!_centerView) {
        _centerView = [[AFOTreeViewCenter alloc]init];
        _centerView.center = self.center;
    }
    return _centerView;
}
#pragma mark ------ layout
- (AFOTreeViewLayout *)layout{
    if (!_layout) {
        _layout = [[AFOTreeViewLayout alloc]init];
    }
    return _layout;
}
@end
