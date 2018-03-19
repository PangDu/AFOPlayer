//
//  AFOAppTabBarController+AFOAutoRotate.h
//  AFOPlayer
//
//  Created by xueguang xian on 2018/1/26.
//  Copyright © 2018年 AFO Science Technology Ltd. All rights reserved.
//

#import "AFOAppTabBarController.h"

@interface AFOAppTabBarController (AFOAutoRotate)
- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
@end
