//
//  JYBOrderLogisticsModel.h
//  Freight_Company
//
//  Created by ToneWang on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBOrderLogisticsModel : NSObject

@property (nonatomic,copy)NSString *order_logistics_id;      //物流ID

@property (nonatomic,copy)NSString *logistics_title;        //物流信息内容

@property (nonatomic,copy)NSString *create_time;          //操作时间


@end
