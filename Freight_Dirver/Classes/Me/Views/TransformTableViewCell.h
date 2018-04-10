//
//  TransformTableViewCell.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrasformViewController.h"

@interface TransformTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLab, *detailLab, *moneyLab, *timelab;

- (void)update:(TransformModel *)model;

@end
