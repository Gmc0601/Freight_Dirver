//
//  CPBackLocationManager.h
//  Charging
//
//  Created by meitun on 2017/2/15.
//  Copyright © 2017年 dbmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPBackLocationManager : NSObject


@property (nonatomic ,assign)CGFloat currentlogitude;
@property (nonatomic ,assign)CGFloat currentlatitude;

@property (nonatomic ,strong)NSTimer *locationTimer;

+ (CPBackLocationManager *)sharedManager;

- (void)startBackLocation;

- (void)stopBackLocation;

- (void)upLoadAllInfoByWifi;
@end
