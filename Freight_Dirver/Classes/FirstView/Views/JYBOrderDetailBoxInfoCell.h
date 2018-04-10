//
//  JYBOrderDetailBoxInfoCell.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JYBOrderDetailBoxOtherBlock)();

@interface JYBOrderDetailBoxInfoCell : UITableViewCell

@property (nonatomic ,copy)JYBOrderDetailBoxOtherBlock otherBlock;

- (void)updateCellWithIcon:(NSString *)icon title:(NSString *)title value:(NSString *)value other:(BOOL)other;

@end
