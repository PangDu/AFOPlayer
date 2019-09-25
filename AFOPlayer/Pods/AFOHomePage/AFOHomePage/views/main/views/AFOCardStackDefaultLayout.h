//
//  AFOCardStackDefaultLayout.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/14.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)
#define RGBColorC(c)        RGBColor((((int)c) >> 16),((((int)c) >> 8) & 0xff),(((int)c) & 0xff))

typedef void(^cardStackSelectedItem)(CGFloat frosted, NSIndexPath *indexPath);
@interface AFOCardStackDefaultLayout : UICollectionViewLayout
@property (nonatomic, copy) cardStackSelectedItem      cardStackSelectedItem;
@end
