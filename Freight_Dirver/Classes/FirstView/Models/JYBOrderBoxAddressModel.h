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

@property (nonatomic,copy)NSString *loadarea_id;      //区域id

@property (nonatomic,copy)NSString *province;      //省

@property (nonatomic,copy)NSString *city;      //省

@property (nonatomic,copy)NSString *address;      //完善的地点

@property (nonatomic,copy)NSString *address_desc;      //街道、门牌号等

@property (nonatomic,copy)NSString *lon;      //

@property (nonatomic,copy)NSString *lat;      //

@property (nonatomic,copy)NSString *shipment_linkman;      //张星星

@property (nonatomic,copy)NSString *shipment_linkman_phone;      //13899098765

@property (nonatomic,copy)NSString *shipment_address_id;      //id

@property (nonatomic,copy)NSString *boxman_name;

@property (nonatomic,copy)NSString *boxman_phone;




@property (nonatomic,copy)NSString *box_address_id;      //哪箱单地址

@property (nonatomic,copy)NSString *user_id;      //用户

@property (nonatomic,copy)NSString *box_linkman;      //拿箱单联系人

@property (nonatomic,copy)NSString *box_linkman_phone;      //拿箱单联系人电话

@property (nonatomic,copy)NSString *box_address_desc;      //拿箱单地址


@end
