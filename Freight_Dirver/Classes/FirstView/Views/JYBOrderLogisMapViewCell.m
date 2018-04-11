//
//  JYBOrderLogisMapViewCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/4/8.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderLogisMapViewCell.h"
//#import "MAMapView.h"
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import "JYBOrderBoxAddressModel.h"
//#import "JYBStationPointModel.h"

@interface JYBOrderLogisMapViewCell ()//<MAMapViewDelegate>

//@property (nonatomic ,strong)MAMapView *mapView;
//
//@property (nonatomic ,strong)NSMutableArray *allArr;
//
//@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation JYBOrderLogisMapViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    
//    [self.contentView addSubview:self.mapView];
}

//- (void)updateCellWithModel:(JYBOrderListModel *)model{
//    
//    [self.mapView removeAnnotations:self.annotations];
//    [self.annotations removeAllObjects];
//    [self.allArr removeAllObjects];
//    
//    
//    JYBStationPointModel *pointModel = [[JYBStationPointModel alloc] init];
//    pointModel.lat = model.driver_lat;
//    pointModel.lon = model.driver_lon;
//    
//    pointModel.type = 1;
//    
//    [self.allArr addObject:pointModel];
//    
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
//    
//    for (int i = 0; i<self.allArr.count; i++) {
//        JYBStationPointModel *mapModel = [self.allArr objectAtIndex:i];
//        CLLocation *location = [[CLLocation alloc] initWithLatitude:mapModel.lat.floatValue longitude:mapModel.lon.floatValue];
//        
//        MAPointAnnotation *pointAnnotaiton = [[MAPointAnnotation alloc] init];
//        [pointAnnotaiton setCoordinate:location.coordinate];
//        [self.annotations addObject:pointAnnotaiton];
//        
//    }
//    
//    
//    [self.mapView addAnnotations:self.annotations];
//    
//    CLLocation *centerlocation = [[CLLocation alloc] initWithLatitude:model.driver_lat.floatValue longitude:model.driver_lon.floatValue];
//    [self.mapView setCenterCoordinate:centerlocation.coordinate];
//    
//    [self.mapView setZoomLevel:12 animated:NO];
//    
//    self.mapView.frame = CGRectMake(0, 0, kScreenW, SizeWidth(150));
//}
//
//
//#pragma mark - MAMapviewDelegate
//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
//        static NSString *pointReuseIdentifier = @"pointReuseIdentifier";
//        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIdentifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIdentifier];
//            
////            annotationView.canShowCallout            = YES;
//            //            annotationView.animatesDrop              = YES;
//            annotationView.draggable                 = YES;
//        }
//        
//        
//        NSInteger index = [self.annotations indexOfObject:annotation];
//        JYBStationPointModel *subModel = self.allArr[index];
//        if (subModel.type == 1) {
//            annotationView.image = [UIImage imageNamed:@"jxz_icon_hc"];
//        }else{
//            annotationView.image = [UIImage imageNamed:@"ckqp_icon_nhd"];
//        }
//        
//        return annotationView;
//    }
//    
//    return nil;
//}
//
//
//- (MAMapView *)mapView{
//    if(!_mapView){
//       _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeWidth(150))];
//        [_mapView setDelegate:self];
//        _mapView.userInteractionEnabled = NO;
//
//    }
//    
//    return _mapView;
//}
//
//
//- (NSMutableArray *)allArr{
//    if (!_allArr) {
//        _allArr = [[NSMutableArray alloc] init];
//    }
//    return _allArr;
//}
//
//- (NSMutableArray *)annotations{
//    if (_annotations == nil) {
//        _annotations = [[NSMutableArray alloc] init];
//    }
//    return _annotations;
//}

@end
