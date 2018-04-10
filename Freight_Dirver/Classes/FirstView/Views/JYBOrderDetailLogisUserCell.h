//
//  JYBOrderDetailLogisUserCell.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBOrderListModel.h"

typedef void(^JYBOrderDetailLogisBlock)();

@interface JYBOrderDetailLogisUserCell : UITableViewCell

@property (nonatomic ,copy)JYBOrderDetailLogisBlock logisPhoneBlock;

- (void)updateCellWithModel:(JYBOrderListModel *)model;

@end
