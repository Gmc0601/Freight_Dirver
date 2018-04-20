//
//  CPBackLocationManager.m
//  Charging
//
//  Created by meitun on 2017/2/15.
//  Copyright © 2017年 dbmao. All rights reserved.
//

#import "CPBackLocationManager.h"
#import <AMapLocationKit/AMapLocationKit.h>

@interface CPBackLocationManager ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation CPBackLocationManager

+ (CPBackLocationManager *)sharedManager{
    static CPBackLocationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CPBackLocationManager alloc] init];
        [sharedManager configLocationManager];
    });
    return sharedManager;
}

- (void)configLocationManager{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    self.locationManager.distanceFilter = 1000;
    self.locationManager.locatingWithReGeocode = YES;
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=9) {
        //设置允许在后台定位
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    }

}


- (void)startBackLocation{
    
    [self updateLocation];
    
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    

}

- (void)updateLocation{
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录
            [self.locationManager startUpdatingLocation];
        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录

        }
    }else {
        //   未登录
    }
    

}


- (void)stopBackLocation{
    
    [self.locationManager stopUpdatingLocation];

}


#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    NSLog(@"back ----------------------------- location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    if ([NSString stringIsNilOrEmpty:[NSString stringWithFormat:@"%lf",location.coordinate.latitude]] || [NSString stringIsNilOrEmpty:[NSString stringWithFormat:@"%lf",location.coordinate.longitude]] ) {
//        return;
//    }
//    self.currentlatitude = location.coordinate.latitude;
//    self.currentlogitude = location.coordinate.longitude;
//
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic addUnEmptyString:[NSString stringWithFormat:@"%lf",location.coordinate.longitude] forKey:@"driver_lon"];
//    [dic addUnEmptyString:[NSString stringWithFormat:@"%lf",location.coordinate.latitude] forKey:@"driver_lat"];
//    [dic addUnEmptyString:[NSString stringWithFormat:@"%lf",location.coordinate.latitude] forKey:@"lon_lat_address"];
//
//
//    NSLog(@"%@", dic);
//    [HttpRequest postPath:@"/Driver/Order/updateOrderDriverLonLat" params:dic resultBlock:^(id responseObject, NSError *error) {
//
//        NSLog(@"%@", responseObject);
//        if([error isEqual:[NSNull null]] || error == nil){
//            NSLog(@"success");
//        }
//        NSDictionary *datadic = responseObject;
//        if ([datadic[@"success"] intValue] == 1) {
//
//
//        }else {
//
//        }
//    }];
//
}


/**
 *  @brief 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
 *  @param manager 定位 AMapLocationManager 类。
 *  @param location 定位结果。
 *  @param reGeocode 逆地理信息。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录

        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
            return;
        }
    }else {
        //   未登录
        return;
    }
    
    
    NSLog(@"back ----------------------------- location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if ([NSString stringIsNilOrEmpty:[NSString stringWithFormat:@"%lf",location.coordinate.latitude]] || [NSString stringIsNilOrEmpty:[NSString stringWithFormat:@"%lf",location.coordinate.longitude]] ) {
        return;
    }
    self.currentlatitude = location.coordinate.latitude;
    self.currentlogitude = location.coordinate.longitude;
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:[NSString stringWithFormat:@"%lf",location.coordinate.longitude] forKey:@"driver_lon"];
    [dic addUnEmptyString:[NSString stringWithFormat:@"%lf",location.coordinate.latitude] forKey:@"driver_lat"];
    [dic addUnEmptyString:reGeocode.formattedAddress forKey:@"lon_lat_address"];
    
    
    NSLog(@"%@", dic);
    [HttpRequest postPath:@"/Driver/Order/updateOrderDriverLonLat" params:dic resultBlock:^(id responseObject, NSError *error) {
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            
        }else {
            
        }
    }];
    
    
    
}


//- (void)upLoadAllInfoByWifi{
//    
//    [self upLoadStationByWifi];
//    [self upLoadPopulationNumByWifi];
//    [self upLoadCarCollectionByWifi];
//    [self upLoadPartrolByWifi];
//    
//}
//

//
//- (void)upLoadStationByWifi{
//
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
//
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        if ([userdefaults objectForKey:CPStationUpLoad]) {
//
//            NSMutableArray *footmarkArray = [[userdefaults objectForKey:CPStationUpLoad] mutableCopy];
//
//            for (NSMutableDictionary *subDic in footmarkArray) {
//
//                [[CPNetworkAdapter sharedAdapter] uploadStationInfoByDicFrom:self station_id:nil subParameters:subDic succeededHandle:^(NSString *info) {
//
//                } failedHandler:^(NSError *error, NSString *errmsg) {
//
//                }];
//            }
//
//            [footmarkArray removeAllObjects];
//            [userdefaults setObject:footmarkArray forKey:CPStationUpLoad];
//
//        }
//
//    }
//
//}
//
//- (void)upLoadPopulationNumByWifi{
//
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
//
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        if ([userdefaults objectForKey:CPPopulationUpLoad]) {
//
//            NSMutableArray *footmarkArray = [[userdefaults objectForKey:CPPopulationUpLoad] mutableCopy];
//
//            for (NSMutableDictionary *subDic in footmarkArray) {
//
//                [[CPNetworkAdapter sharedAdapter] uploadPopulationInfoByDicFrom:self population_id:nil subParameters:subDic succeededHandle:^(NSString *info) {
//
//                } failedHandler:^(NSError *error, NSString *errmsg) {
//
//                }];
//            }
//
//            [footmarkArray removeAllObjects];
//            [userdefaults setObject:footmarkArray forKey:CPPopulationUpLoad];
//
//        }
//
//    }
//}
//
//- (void)upLoadCarCollectionByWifi{
//
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
//
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        if ([userdefaults objectForKey:CPCarCollectionUpLoad]) {
//
//            NSMutableArray *footmarkArray = [[userdefaults objectForKey:CPCarCollectionUpLoad] mutableCopy];
//
//            for (NSMutableDictionary *subDic in footmarkArray) {
//
//                [[CPNetworkAdapter sharedAdapter] uploadCarInfoByDicFrom:self subParameters:subDic succeededHandle:^(NSString *info) {
//
//                } failedHandler:^(NSError *error, NSString *errmsg) {
//
//                }];
//            }
//
//            [footmarkArray removeAllObjects];
//            [userdefaults setObject:footmarkArray forKey:CPCarCollectionUpLoad];
//
//        }
//
//    }
//}
//
//- (void)upLoadPartrolByWifi{
//
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
//
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//        if ([userdefaults objectForKey:CPPartrolUpLoad]) {
//
//            NSMutableArray *footmarkArray = [[userdefaults objectForKey:CPPartrolUpLoad] mutableCopy];
//
//            for (NSMutableDictionary *subDic in footmarkArray) {
//
//                [[CPNetworkAdapter sharedAdapter] uploadPartorlInfoByDicFrom:self subParameters:subDic succeededHandle:^(NSString *info) {
//
//                } failedHandler:^(NSError *error, NSString *errmsg) {
//
//                }];
//            }
//
//            [footmarkArray removeAllObjects];
//            [userdefaults setObject:footmarkArray forKey:CPPartrolUpLoad];
//
//        }
//
//    }
//}

@end
