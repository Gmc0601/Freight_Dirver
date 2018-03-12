//
//  AddInfoModel.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/18.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddInfoModel : NSObject

@property (nonatomic, copy) NSString *companyName, *userName, *userId, *sosconnact, *sosphone,*alwaysLine;

@property (nonatomic, copy) NSString *carNum, *carSoure, *white_card, *identity_front, *identity_back, *driver_card, *driving_card;

@property (nonatomic, copy) NSString * driver_id, *fleet_id;

@property (nonatomic) BOOL haveWhite;

@end
