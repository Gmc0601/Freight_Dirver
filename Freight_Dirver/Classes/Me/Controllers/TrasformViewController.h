//
//  TrasformViewController.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

@interface TransformModel : NSObject
@property (nonatomic, copy) NSString *change_type, *add_subtract, *change_price, *box_no, *create_time;
@end

@interface TrasformViewController : CCBaseViewController

@end
