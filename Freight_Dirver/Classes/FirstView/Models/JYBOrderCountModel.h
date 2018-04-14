//
//  JYBOrderCountModel.h
//  Freight_Company
//
//  Created by ToneWang on 2018/4/10.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBOrderCountModel : NSObject

@property (nonatomic,copy)NSString *wait_box;      //待提箱订单数

@property (nonatomic,copy)NSString *transport;      //运输中订单数

@property (nonatomic,copy)NSString *completed;      // 已完成订单数

@property (nonatomic,copy)NSString *allotted;      // 已接单订单数

@property (nonatomic,copy)NSString *under_way;      // 运输中订单数


@end
