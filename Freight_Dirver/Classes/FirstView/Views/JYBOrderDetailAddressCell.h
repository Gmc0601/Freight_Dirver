//
//  JYBOrderDetailAddressCell.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBOrderBoxAddressModel.h"

typedef void(^JYBOrderDetailPhoneBlock)(JYBOrderBoxAddressModel *addModel);

@interface JYBOrderDetailAddressCell : UITableViewCell

@property (nonatomic ,copy)JYBOrderDetailPhoneBlock phoneBlock;

- (void)updateCellWithModel:(JYBOrderBoxAddressModel *)model isBox:(BOOL)isBox box_no:(NSString *)box_no;

@end
