//
//  LoginViewController.h
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface CompanyInfo : NSObject

@property (nonatomic, copy) NSString *company_name, *company_status, *refund_desc, *total_amount;

@end
@interface UserModel : NSObject

@property (nonatomic , copy) NSString              * fleet_id;
@property (nonatomic , copy) NSString              * driving_card;
@property (nonatomic , copy) NSString              * month_order;
@property (nonatomic , copy) NSString              * month_price;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * white_card;
@property (nonatomic , copy) NSString              * evel_score;
@property (nonatomic , copy) NSString              * driver_name;
@property (nonatomic , copy) NSString              * driver_linkman;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * driver_identity;
@property (nonatomic , copy) NSString              * order_count;
@property (nonatomic , copy) NSString              * driver_phone;
@property (nonatomic , copy) NSString              * driver_total_amount;
@property (nonatomic , copy) NSString              * route_line;
@property (nonatomic , copy) NSString              * driver_id;
@property (nonatomic , copy) NSString              * refund_time;
@property (nonatomic , copy) NSString              * driver_face;
@property (nonatomic , copy) NSString              * is_white_card;
@property (nonatomic , copy) NSString              * driver_linkman_phone;
@property (nonatomic , copy) NSString              * eval_num;
@property (nonatomic , copy) NSString              * identity_front;
@property (nonatomic , copy) NSString              * identity_back;
@property (nonatomic , copy) NSString              * car_no;
@property (nonatomic , copy) NSString              * total_price;
@property (nonatomic , copy) NSString              * fleet_name;
@property (nonatomic , copy) NSString              * reason_text;
@property (nonatomic , copy) NSString              * update_time;
@property (nonatomic , copy) NSString              * user_status;
@property (nonatomic , copy) NSString              * driver_card;
@property (nonatomic , copy) NSString              * car_bridge;
@property (nonatomic , copy) NSString              * boxman_id;


@end

typedef enum LoginUserType {
    User_Driver = 0,
    User_Worker = 1,
}LoginUserType;

@interface LoginViewController : CCBaseViewController

@property (nonatomic, assign) LoginUserType type;

@property (nonatomic, copy) void(^homeBlocl)();

@end
