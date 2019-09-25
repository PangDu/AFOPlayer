//
//  AFOHPDetailCell.h
//  AFOHomePage
//
//  Created by xueguang xian on 2017/12/26.
//  Copyright © 2017年 AFO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AFOHPDetailCellBlock)(NSString *albumTitle,
                                    NSString *title,
                                    UIImage  *image,
                                    NSInteger type);

@interface AFOHPDetailCell : UITableViewCell
@property (nonatomic, copy) AFOHPDetailCellBlock block;
@property (nonatomic, assign, readonly) CGSize imageSize;
@end
