//
//  JYBOrderListModel.m
//  Freight_Company
//
//  Created by ToneWang on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderListModel.h"

@implementation JYBOrderListModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"logistics" : @"JYBOrderLogisticsModel",@"box_address":@"JYBOrderBoxAddressModel",@"shipment_address":@"JYBOrderBoxAddressModel"};
}


@end
