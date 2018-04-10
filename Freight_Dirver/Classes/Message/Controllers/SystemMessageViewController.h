//
//  SystemMessageViewController.h
//  Freight_Company
//
//  Created by cc on 2018/1/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"

@interface SystemModel : NSObject

@property (nonatomic, copy) NSString *msg_id, *msg_type, *content, *is_read, *user_id, *planfrom, *create_time, *update_time, *order_id;

@end

@interface SystemMessageViewController : BaseViewController

@end
