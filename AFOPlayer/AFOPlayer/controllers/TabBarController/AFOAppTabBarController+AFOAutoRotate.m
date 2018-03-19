//
//  AFOAppTabBarController+AFOAutoRotate.m
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppTabBarController+AFOAutoRotate.h"

@implementation AFOAppTabBarController (AFOAutoRotate)
- (BOOL)shouldAutorotate{
    
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
}
@end
