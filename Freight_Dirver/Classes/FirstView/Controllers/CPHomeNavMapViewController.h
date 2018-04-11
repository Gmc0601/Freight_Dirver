//
//  CPHomeNavMapViewController.h
//  Charging
//
//  Created by meitun on 2016/11/3.
//  Copyright © 2016年 dbmao. All rights reserved.
//

#import "CCBaseViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface CPHomeNavMapViewController : CCBaseViewController

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@end
