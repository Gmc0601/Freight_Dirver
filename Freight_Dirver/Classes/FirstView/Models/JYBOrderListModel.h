//
//  JYBOrderListModel.h
//  Freight_Company
//
//  Created by ToneWang on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBOrderListModel : NSObject


@property (nonatomic,copy)NSString *order_id;       //订单ID

@property (nonatomic,copy)NSString *order_no;       //订单编号

@property (nonatomic,copy)NSString *create_time;       //下单时间

@property (nonatomic,copy)NSString *box_create_time;       //提箱时间


@property (nonatomic,copy)NSString *order_status;    //订单状态 状态：0-待支付 10-派单中 20-已接单 30-进行中 31-已到港（待支付,支付额外费用）32-已到港（待支付,额外费用拒绝） 40-已到港（待支付,支付额外费用） 50-已完成 60-已取消

@property (nonatomic,copy)NSString *order_price;     //运价（订单显示价格）

@property (nonatomic,copy)NSString *port_name;       //港口名称

@property (nonatomic,copy)NSString *port_id;          //港口id

@property (nonatomic,copy)NSString *box_address_id;          //拿单箱地址id

@property (nonatomic,copy)NSString *dock_name;       //码头名称

@property (nonatomic,copy)NSString *pick_no;          //提单号

@property (nonatomic,copy)NSString *shipment_time;       //装箱时间

@property (nonatomic,copy)NSString *cutoff_time;          //截关时间

@property (nonatomic,copy)NSString *order_type;          //箱子型号

@property (nonatomic,copy)NSString *message;          //给司机捎话（订单备注）

@property (nonatomic,copy)NSString *weight_desc;          //货重

@property (nonatomic,copy)NSString *weight_price;          //货重价格

@property (nonatomic,copy)NSString *yard_name;          //提箱名称

@property (nonatomic,copy)NSString *yard_price;          //提箱价格

@property (nonatomic,copy)NSString *other_price;          //其他费用价格

@property (nonatomic,copy)NSString *other_price_desc;          //其他费用说明

@property (nonatomic,copy)NSString *box_no;          //提箱号

@property (nonatomic,copy)NSString *car_no;          //car_no

@property (nonatomic,copy)NSArray *box_img;          //箱子照片

@property (nonatomic,copy)NSString *close_no;          //封号

@property (nonatomic,copy)NSString *driver_id;          //司机ID

@property (nonatomic,copy)NSString *driver_phone;          //司机电话

@property (nonatomic,copy)NSString *driver_name;          //司机名

@property (nonatomic,copy)NSString *driver_lat;          //lat

@property (nonatomic,copy)NSString *driver_lon;          //lon

@property (nonatomic,copy)NSString *dock_id;          //dock_id

@property (nonatomic,copy)NSString *weight_id;          //weight_id

@property (nonatomic,copy)NSString *yard_id;          //yard_id

@property (nonatomic,copy)NSArray *other_price_img;          //额外费用凭证图片

@property (nonatomic,strong)NSArray *shipment_address;     //装箱点地址（具体数据在下面列出） 装箱地址【数组】

@property (nonatomic,strong)NSArray *box_address;            //提箱地址【数组】

@property (nonatomic,strong)NSArray *logistics;            //物流信息【数组】

@property (nonatomic,copy)NSString *loadarea_name;          //yard_id


@end
