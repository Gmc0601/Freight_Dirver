//
//  JYBHomeOrderLogisItemCell.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBOrderLogisticsModel.h"

@interface JYBHomeOrderLogisItemCell : UITableViewCell

@property (nonatomic ,strong)UIButton    *dotBtn;          ///<标识

@property (nonatomic ,strong)UIView      *topLine;          ///<上划线

@property (nonatomic ,strong)UIView      *bottomLine;       ///<下划线

- (void)updateCellWithModel:(JYBOrderLogisticsModel *)model;

@end
