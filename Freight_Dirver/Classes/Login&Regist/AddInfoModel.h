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

@property (nonatomic, copy) NSString *carNum, *carSoure, *imageStr;

@property (nonatomic) BOOL haveWhite;

@end
