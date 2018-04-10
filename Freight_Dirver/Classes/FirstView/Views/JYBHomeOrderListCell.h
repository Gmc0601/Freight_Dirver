//
//  JYBHomeOrderListCell.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBOrderListModel.h"


typedef enum : NSUInteger {
    JYBHomeOrderListActionContact,
    JYBHomeOrderListActionOrder,
    JYBHomeOrderListActionPay,
} JYBHomeOrderListAction;


typedef void(^JYBHomeOrderListBlock)(JYBHomeOrderListAction action,JYBOrderListModel *listModel);

@interface JYBHomeOrderListCell : UITableViewCell

- (void)udpateCellWithModel:(JYBOrderListModel *)listModel;

@property (nonatomic ,copy)JYBHomeOrderListBlock listBlock;

@end
