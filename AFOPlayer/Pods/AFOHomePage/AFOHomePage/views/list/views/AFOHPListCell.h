//
//  AFOHPListCell.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/27.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AFOHPListCellBlock)(NSString *title,
                                  NSString *artists,
                                  UIImage *image,
                                  NSInteger type);
@interface AFOHPListCell : UITableViewCell
@property (nonatomic, assign, readonly) CGSize     imageSize;
@property (nonatomic, copy) AFOHPListCellBlock     block;
@end
