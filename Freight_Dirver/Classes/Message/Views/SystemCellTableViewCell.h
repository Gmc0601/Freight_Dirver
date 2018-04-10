//
//  SystemCellTableViewCell.h
//  Freight_Company
//
//  Created by cc on 2018/1/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemMessageViewController.h"

@interface SystemCellTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *whiteView;

@property (nonatomic, retain) UILabel *contentLab;

- (void)update:(SystemModel *)model;

@end
