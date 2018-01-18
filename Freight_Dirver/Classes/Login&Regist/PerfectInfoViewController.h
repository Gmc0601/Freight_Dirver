//
//  PerfectInfoViewController.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "AddInfoModel.h"

typedef NS_ENUM (NSInteger, AddInfoType)   {
    
    AddOne = 0,
    
    AddTwo = 1,
    
    AddThree = 2
    
};

@interface PerfectInfoViewController : CCBaseViewController

@property (nonatomic, assign) AddInfoType type;

@property (nonatomic, retain) AddInfoModel *model;

@end
