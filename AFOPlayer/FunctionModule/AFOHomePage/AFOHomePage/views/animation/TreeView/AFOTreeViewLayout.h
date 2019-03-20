//
//  AFOTreeViewLayout.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/15.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFOTreeViewAround;
@interface AFOTreeViewLayoutPoint : NSObject
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;

@property (nonatomic, assign) CGPoint startDistance;
@property (nonatomic, assign) CGFloat endDistance;
@property (nonatomic, assign) CGFloat nearDistance;
@property (nonatomic, assign) CGFloat farDistance;
@end


@interface AFOTreeViewLayout : NSObject
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat  aroundWidth;
@property (nonatomic, assign) CGFloat  aroundHeigh;
- (void)settingAroundView:(id)aroundView
                 treeView:(id)treeView
                   layout:(id)layout
                    index:(NSInteger)index;
@end
