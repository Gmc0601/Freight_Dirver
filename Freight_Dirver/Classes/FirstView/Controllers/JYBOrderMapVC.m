//
//  JYBOrderMapVC.m
//  Freight_Company
//
//  Created by ToneWang on 2018/4/9.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderMapVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "JYBOrderBoxAddressModel.h"
#import "JYBStationPointModel.h"
#import <CoreLocation/CoreLocation.h>

@interface JYBOrderMapVC ()<MAMapViewDelegate>

@property (nonatomic ,strong)MAMapView *mapView;

@property (nonatomic ,strong)UIButton *backBtn;

@property (nonatomic ,strong)NSMutableArray *allArr;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic ,strong)UIView     *bottomView;

@end

@implementation JYBOrderMapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetFather];
    
    [self.view addSubview:self.mapView];
    
    
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.bottomView];
    
    [self setUIWithModel:self.listModel];
    
}

- (void)resetFather {
    self.navigationView.hidden = YES;
    
}

- (void)setUIWithModel:(JYBOrderListModel *)model{
    
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    [self.allArr removeAllObjects];
    
    
    JYBStationPointModel *pointModel = [[JYBStationPointModel alloc] init];
    pointModel.lat = model.driver_lat;
    pointModel.lon = model.driver_lon;

    pointModel.type = 1;
    
    [self.allArr addObject:pointModel];
    
//    for (JYBOrderBoxAddressModel *addreModel in model.shipment_address) {
//        JYBStationPointModel *subpointModel = [[JYBStationPointModel alloc] init];
//        subpointModel.lat = addreModel.lat;
//        subpointModel.lon = addreModel.lon;
//        subpointModel.type = 2;
//
//        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:pointModel.lat.floatValue longitude:pointModel.lon.floatValue];
//        CLLocation *targetLocation = [[CLLocation alloc] initWithLatitude:addreModel.lat.floatValue longitude:addreModel.lon.floatValue];
//        CLLocationDistance distance = [currentLocation distanceFromLocation:targetLocation];
//        subpointModel.distance = distance/1000;
//
//        [self.allArr addObject:subpointModel];
//    }
    
    for (int i = 0; i<self.allArr.count; i++) {
        JYBStationPointModel *mapModel = [self.allArr objectAtIndex:i];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:mapModel.lat.floatValue longitude:mapModel.lon.floatValue];
        
        MAPointAnnotation *pointAnnotaiton = [[MAPointAnnotation alloc] init];
        if (i == 0) {
            pointAnnotaiton.title = @"运输车辆";
        }else{
            pointAnnotaiton.title = [self __culateTimeWithDistance:mapModel.distance];
        }
        [pointAnnotaiton setCoordinate:location.coordinate];
        [self.annotations addObject:pointAnnotaiton];
        
    }
    
    
    [self.mapView addAnnotations:self.annotations];


    
//
//    if (model.shipment_address.count){
//        JYBStationPointModel *levelModel = [self.allArr objectAtIndex:1];
//
//        CLLocation *centerlocation = [[CLLocation alloc] initWithLatitude:(model.driver_lat.floatValue + levelModel.lat.floatValue)/2 longitude:(model.driver_lon.floatValue + levelModel.lon.floatValue)/2];
//        [self.mapView setCenterCoordinate:centerlocation.coordinate];
//        [self.mapView setZoomLevel:[self __getLevelWithModel:levelModel] animated:NO];
//
//
//    }else{
        CLLocation *centerlocation = [[CLLocation alloc] initWithLatitude:model.driver_lat.floatValue longitude:model.driver_lon.floatValue];
        [self.mapView setCenterCoordinate:centerlocation.coordinate];
        [self.mapView setZoomLevel:12 animated:NO];

//    }
    
    
    
    
}

- (NSInteger)__getLevelWithModel:(JYBStationPointModel *)model{
    
    NSInteger startIdex = 10000;
    
    if(model.distance*1000 < startIdex){
        return 11;
    }else if (model.distance*1000 < startIdex*2){
        return 10;
    }else if (model.distance*1000 < startIdex*4){
        return 9;
    }else if (model.distance*1000 < startIdex*8){
        return 8;
    }else if (model.distance*1000 < startIdex*16){
        return 7;
    }else if (model.distance*1000 < startIdex*32){
        return 6;
    }else if (model.distance*1000 < startIdex*64){
        return 5;
    }else if (model.distance*1000 < startIdex*128){
        return 4;
    }else{
        return 3;
    }
    
    
    
}




- (NSString *)__culateTimeWithDistance:(CGFloat)distance{
    
    if (distance > 60) {
        
        NSInteger hour = distance/60;
        
        NSInteger min = @(distance).integerValue%60;
        
        return [NSString stringWithFormat:@"预计%ld小时%ld分钟后到达",hour,min];

        
    }else{
        return [NSString stringWithFormat:@"预计%.0lf分钟后到达",distance];
    }

}

#pragma mark - MAMapviewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
            
                        annotationView.canShowCallout            = YES;
            //            annotationView.animatesDrop              = YES;
            annotationView.draggable                 = YES;
        }
        
        
        NSInteger index = [self.annotations indexOfObject:annotation];
        JYBStationPointModel *subModel = self.allArr[index];
        if (subModel.type == 1) {
            annotationView.image = [UIImage imageNamed:@"jxz_icon_hc"];
        }else{
            annotationView.image = [UIImage imageNamed:@"ckqp_icon_nhd"];
        }
        
        return annotationView;
    }
    
    return nil;
}

/*!
 @brief 当选中一个annotation views时调用此接口
 @param mapView 地图View
 @param views 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    
    
    NSInteger index = [self.annotations indexOfObject:view.annotation];
    
    JYBStationPointModel *subModel = self.allArr[index];
    
    
}

- (MAMapView *)mapView{
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.bounds.size.height - 70)];
        [_mapView setDelegate:self];
    }
    
    return _mapView;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 44, 44)];
        [_backBtn setImage:[UIImage imageNamed:@"qpdt_icon_fh"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (NSMutableArray *)allArr{
    if (!_allArr) {
        _allArr = [[NSMutableArray alloc] init];
    }
    return _allArr;
}

- (NSMutableArray *)annotations{
    if (_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
    }
    return _annotations;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 70, kScreenW, 70)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel *firLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SizeWidth(150), 70)];
        firLab.text = @"点击";
        firLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        firLab.textAlignment = NSTextAlignmentRight;
        firLab.textColor = RGB(52, 52, 52);
        [_bottomView addSubview:firLab];
        
        UIButton *lastBtn = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(160), 0, 150, 70)];
        [lastBtn setImage:[UIImage imageNamed:@"ckqp_icon_nhd"] forState:UIControlStateNormal];
        lastBtn.titleLabel.font = [UIFont systemFontOfSize:SizeWidth(15)];
        lastBtn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [lastBtn setTitle:@"   查看到达时间" forState:UIControlStateNormal];
        [lastBtn setTitleColor:RGB(52, 52, 52) forState:UIControlStateNormal];
        [_bottomView addSubview:lastBtn];
        
    }
    return _bottomView;
}

@end
