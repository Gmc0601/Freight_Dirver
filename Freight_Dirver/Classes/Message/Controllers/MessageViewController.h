//
//  MessageViewController.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageModel : NSObject

@property (nonatomic, copy) NSString *driver_id, *driver_name, *driver_phone, *driver_face;

@end

@interface MessageViewController : BaseViewController

@property (nonatomic) BOOL boxman;

@end
