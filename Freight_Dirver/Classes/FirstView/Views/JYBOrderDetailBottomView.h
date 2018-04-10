//
//  JYBOrderDetailBottomView.h
//  Freight_Company
//
//  Created by ToneWang on 2018/3/18.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBOrderListModel.h"

typedef void(^JYBOrderDetailBottomScheBlock)();

typedef void(^JYBOrderDetailBottomPayBlock)(BOOL isOther);

@interface JYBOrderDetailBottomView : UIView

@property (nonatomic ,copy)JYBOrderDetailBottomScheBlock  scheBlock;

@property (nonatomic ,copy)JYBOrderDetailBottomPayBlock  payBlock;

- (void)updateBottomView:(JYBOrderListModel *)model;

@end
