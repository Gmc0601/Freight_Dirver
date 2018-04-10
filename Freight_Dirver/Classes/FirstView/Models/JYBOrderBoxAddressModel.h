//
//  JYBOrderBoxAddressModel.h
//  Freight_Company
//
//  Created by ToneWang on 2018/3/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYBOrderBoxAddressModel : NSObject

@property (nonatomic,copy)NSString *loadarea_name;      //名称

@property (nonatomic,copy)NSString *province;      //省

@property (nonatomic,copy)NSString *city;      //省

@property (nonatomic,copy)NSString *address;      //完善的地点

@property (nonatomic,copy)NSString *address_desc;      //街道、门牌号等

@property (nonatomic,copy)NSString *shipment_linkman;      //张星星

@property (nonatomic,copy)NSString *shipment_linkman_phone;      //13899098765

@end
