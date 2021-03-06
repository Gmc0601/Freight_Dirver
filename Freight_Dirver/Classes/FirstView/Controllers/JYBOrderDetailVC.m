//
//  JYBOrderDetailVC.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderDetailVC.h"
#import "JYBOrderDetailLogisUserCell.h"
#import "JYBOrderDetailLogisInfoCell.h"
#import "JYBOrderDetailAddressCell.h"
#import "JYBOrderDetailBoxInfoCell.h"
#import "JYBOrderDetailMarkInfoCell.h"
#import "JYBOrderDetailCostCell.h"
#import "JYBOrderLogisInfoVC.h"
#import "JYBOrderOtherCostVC.h"
#import "JYBOrderListModel.h"
#import "JYBOrderBoxAddressModel.h"
#import "JYBHomeOrderImageCell.h"
#import "JYBOrderDetailBottomView.h"
#import "JYBOrderPayPopView.h"
#import "JYBOrderLogisMapViewCell.h"
#import <YYKit.h>
#import "JYBAlertView.h"
#import "JYBOtherCostInputVC.h"
#import "JYBTiBoxDoneVC.h"
#import "CPHomeNavMapViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "JYBOrderMapVC.h"

typedef enum : NSUInteger {
    JYBOrderDetailTypeLogisInfo,
    JYBOrderDetailTypeLogisMap,
    JYBOrderDetailTypeLogisUser,
    JYBOrderDetailTypeAddressInfo,
    JYBOrderDetailTypeBoxInfo,
    JYBOrderDetailTypeMarkInfo,
    JYBOrderDetailTypeCostInfo,
    JYBOrderDetailTypeOtherCost,
    JYBOrderDetailTypeOrderInfo,
    
} JYBOrderDetailType;

@interface JYBOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,JYBOtherCostInputVCDelegate>

@property (nonatomic ,strong)UITableView *myTableView;

@property (nonatomic ,strong)JYBOrderListModel *detailModel;

@property (nonatomic ,strong)UIView *bottomView;

@property (nonatomic ,strong)UIButton       *commitBtn;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@property (nonatomic ,strong)JYBOrderBoxAddressModel *seleBoxAddModel;

@end

@implementation JYBOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.bottomView];
    [self __fetchOrderDetail];
}

- (void)resetFather {
    
    
    self.titleLab.text = @"";
    [self.rightBar setImage:[UIImage imageNamed:@"nav_icon_dh"] forState:UIControlStateNormal];
    [self.rightBar setTitle:@"客服" forState:UIControlStateNormal];
}

- (void)__fetchOrderDetail{
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:self.order_id forKey:@"order_id"];
    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    
    NSString *path = @"";
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录
            path = @"/Driver/Order/orderDetail";
        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
            path = @"/Boxman/Order/boxmanOrderDetail";
        }
    }else {
        //   未登录
        path = @"/Driver/Order/orderDetail";
    }
    
    [HttpRequest postPath:path params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            weak.detailModel = [JYBOrderListModel modelWithDictionary:datadic[@"data"]];
            [weak __setBottomView];
            self.titleLab.text = [weak __getNavTitleWithModel:self.detailModel];
            
            [weak.myTableView reloadData];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}


- (void)__setBottomView{
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录

            
            if (self.detailModel.order_status.integerValue == 20){
                self.bottomView.hidden = NO;
                self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - SizeWidth(55));
                [self.commitBtn setTitle:@"完成提箱" forState:UIControlStateNormal];
            }else if (self.detailModel.order_status.integerValue == 30){
                self.bottomView.hidden = NO;
                self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - SizeWidth(55));
                [self.commitBtn setTitle:@"已装货进港" forState:UIControlStateNormal];
            }else{
                self.bottomView.hidden = YES;
                self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
                
            }
            
            
        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
            
//            if (self.detailModel.order_status.integerValue == 30){
//                self.bottomView.hidden = NO;
//                self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - SizeWidth(55));
//                [self.commitBtn setTitle:@"完成装车" forState:UIControlStateNormal];
//            }else{
                self.bottomView.hidden = YES;
                self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
//            }

        }
    }else {
        //   未登录

        self.bottomView.hidden = YES;
        self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);

    }

}

- (void)more:(UIButton *)sender{
    [[[JYBAlertView alloc] initWithTitle:@"确定联系平台客服？" message:[ConfigModel getStringforKey:Servicephone] cancelItem:@"取消" sureItem:@"确认" clickAction:^(NSInteger index) {
        if (index == 1) {
            NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",[ConfigModel getStringforKey:Servicephone]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
        }
    }] show];
    
}

- (NSString *)__getNavTitleWithModel:(JYBOrderListModel *)model{
    
    //订单状态 状态：0-待支付 10-派单中 20-已接单 30-进行中 40-已到港（待支付,支付额外费用） 50-已完成 60-已取消
    
    switch (model.order_status.integerValue) {
            case 0:
            return @"待确认";
            break;
            case 10:
            return @"派单中";
            break;
            case 20:
            return @"已接单";
            break;
            case 30:
            return @"运输中";
            break;
            case 31:
            return @"已进港(额外费用待审核)";
            break;
            case 32:
            return @"已进港(额外费用待审核)";
            break;
            case 40:
            return @"确认额外费用";
            break;
            case 50:
            return @"已完成";
            break;
            case 60:
            return @"已取消";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)__fetchBoxTypeWithType:(NSString *)type{
    
    //    其中对应英文 small_carpool-小柜拼车 small_single-小柜单放 big_cabinet-大柜 tall_cabinet-高柜 super_tall_cabinet-超高柜
    
    if ([type isEqualToString:@"small_carpool"]) {
        return @"1x20GP(拼)";
    }else if ([type isEqualToString:@"small_single"]){
        return @"1x20GP";
    }else if ([type isEqualToString:@"big_cabinet"]){
        return @"1x40GP";
    }else if ([type isEqualToString:@"tall_cabinet"]){
        return @"1x40HQ";
    }else{
        return @"1x45HQ";
    }
    
}


- (void)__phoneWithPhone:(NSString *)phone{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认拨打\n%@",phone] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)__navAction:(JYBOrderBoxAddressModel *)model currLoc:(CLLocation *)curLoc{
    CPHomeNavMapViewController *vc = [[CPHomeNavMapViewController alloc] init];
    vc.startPoint = [AMapNaviPoint locationWithLatitude:curLoc.coordinate.latitude longitude:curLoc.coordinate.longitude];
    vc.endPoint   = [AMapNaviPoint locationWithLatitude:model.lat.floatValue longitude:model.lon.floatValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)__turnToOtherCostSchVC{
    JYBOrderOtherCostVC *vc = [[JYBOrderOtherCostVC alloc] init];
    vc.orderModel = self.detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)__fetCurrentLocationWithModel:(JYBOrderBoxAddressModel *)model{
    
    self.seleBoxAddModel = model;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置定位超时时间
    [self.locationManager setLocationTimeout:10];
    
    //设置逆地理超时时间
    [self.locationManager setReGeocodeTimeout:10];
    
    
    
    
    
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
//    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//
//            if (error.code == AMapLocationErrorLocateFailed)
//            {
//                return;
//            }
//        }
//
//
//        NSLog(@"location:%@", location);
//
//        if (regeocode)
//        {
//            NSLog(@"reGeocode:%@", regeocode);
//        }
//    }];
    
    [self reGeocodeAction];
}


- (void)reGeocodeAction
{
    [ConfigModel showHud:self];

    //进行单次带逆地理定位请求
    __weak typeof(self)weakSelf= self;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [ConfigModel hideHud:weakSelf];

        NSLog(@"~~~~~~~~~~~~%@",regeocode);
        if (error) {
            
        }else{

            [weakSelf __navAction:self.seleBoxAddModel currLoc:location];

        }
        
    }];
}


#pragma mark - tableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == JYBOrderDetailTypeLogisUser) {
        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                return 0;
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                return ([NSString stringIsNilOrEmpty:self.detailModel.driver_id] || self.detailModel.order_status.integerValue == 0 || self.detailModel.order_status.integerValue == 10 || self.detailModel.order_status.integerValue == 60)?0:1;
            }
            return 0;
        }else {
            //   未登录
            return 0;
        }
        
    }else if (section == JYBOrderDetailTypeLogisInfo){
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                return 0;
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                return self.detailModel.logistics.count?1:0;
            }
            return 0;
        }else {
            //   未登录
            return 0;
        }

    }else if (section == JYBOrderDetailTypeLogisMap){
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                return 0;
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                return (self.detailModel.order_status.integerValue == 30 )?1:0;
            }
            return 0;
        }else {
            //   未登录
            return 0;
        }
    }else if (section == JYBOrderDetailTypeAddressInfo){
        return self.detailModel.shipment_address.count + 1;
    }else if (section == JYBOrderDetailTypeBoxInfo){
        return [self __fetchTypeBoxInfoNum];
    }else if (section == JYBOrderDetailTypeMarkInfo){
        return [NSString stringIsNilOrEmpty:self.detailModel.message]?0:1;
    }else if (section == JYBOrderDetailTypeCostInfo){
        return 0;
    }else if (section == JYBOrderDetailTypeOtherCost){

        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                return ([NSString stringIsNilOrEmpty:self.detailModel.other_price] || self.detailModel.other_price.floatValue <= 0 || self.detailModel.order_status.integerValue ==20 || self.detailModel.order_status.integerValue ==30)?0:1;
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                return 0;
            }
            return 0;
            
        }else {
            //   未登录
            return 0;
        }
        
        
    }else{
        return 1;
    }
}

- (NSInteger)__fetchTypeBoxInfoNum{
    if (self.detailModel) {
        if (self.detailModel.order_status.integerValue == 30 || self.detailModel.order_status.integerValue == 31 ||
            self.detailModel.order_status.integerValue == 32 ||
            self.detailModel.order_status.integerValue == 40 || self.detailModel.order_status.integerValue == 50 ) {
            if (self.detailModel.box_img.count) {
                return 7;
            }else{
                return 6;
            }
            
        }else{
            return 3;
        }
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == JYBOrderDetailTypeLogisUser) {
        return SizeWidth(85);
    }else if (indexPath.section == JYBOrderDetailTypeLogisInfo){
        return SizeWidth(90);
    }else if (indexPath.section == JYBOrderDetailTypeLogisMap){
        return SizeWidth(200);
    }
    else if (indexPath.section == JYBOrderDetailTypeAddressInfo){
        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录

                if (indexPath.row == 0) {
                    return SizeWidth(45);
                }else{
                    return SizeWidth(110);
                }
                
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                if (indexPath.row == 0) {
                    return SizeWidth(45);
                }else{
                    return SizeWidth(70);
                }
            }
            if (indexPath.row == 0) {
                return SizeWidth(45);
            }else{
                return SizeWidth(110);
            }
        }else {
            //   未登录
            if (indexPath.row == 0) {
                return SizeWidth(45);
            }else{
                return SizeWidth(110);
            }
            
        }
        
        

    }else if (indexPath.section == JYBOrderDetailTypeBoxInfo){
        if (indexPath.row == 6) {
            return SizeWidth(110);
        }else{
            return SizeWidth(55);
        }
    }else if (indexPath.section == JYBOrderDetailTypeMarkInfo){
        return UITableViewAutomaticDimension;
    }else if (indexPath.section== JYBOrderDetailTypeCostInfo){
        return SizeWidth(50);
    }else if (indexPath.section== JYBOrderDetailTypeOtherCost){
        return SizeWidth(55);
    }
    else{
        return SizeWidth(65);
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == JYBOrderDetailTypeLogisUser) {
        return CGFLOAT_MIN;
    }else if (section == JYBOrderDetailTypeLogisInfo){
        return CGFLOAT_MIN;
    }else if (section == JYBOrderDetailTypeLogisMap){
        return CGFLOAT_MIN;
    }else if (section == JYBOrderDetailTypeAddressInfo){
        return SizeWidth(10);
    }else if (section == JYBOrderDetailTypeBoxInfo){
        return SizeWidth(10);
    }else if (section == JYBOrderDetailTypeMarkInfo){
        return [NSString stringIsNilOrEmpty:self.detailModel.message]?CGFLOAT_MIN:SizeWidth(10);
    }else if (section== JYBOrderDetailTypeCostInfo){
        return CGFLOAT_MIN;
    }else if (section== JYBOrderDetailTypeOtherCost){
        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                return ([NSString stringIsNilOrEmpty:self.detailModel.other_price] || self.detailModel.other_price.floatValue <= 0 || self.detailModel.order_status.integerValue ==20 || self.detailModel.order_status.integerValue ==30)?CGFLOAT_MIN:SizeWidth(10);
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                return CGFLOAT_MIN;
            }
            return CGFLOAT_MIN;

        }else {
            //   未登录
            return CGFLOAT_MIN;
        }
    }else{
        return SizeWidth(10);
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == JYBOrderDetailTypeLogisUser) {
        
        JYBOrderDetailLogisUserCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailLogisUserCell class]) forIndexPath:indexPath];
        [cell updateCellWithModel:self.detailModel];
        WeakObj(self);
        [cell setLogisPhoneBlock:^{
            [selfWeak __phoneWithPhone:selfWeak.detailModel.driver_phone];
        }];
        return cell;
        
    }else if (indexPath.section == JYBOrderDetailTypeLogisInfo){
        JYBOrderDetailLogisInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailLogisInfoCell class]) forIndexPath:indexPath];
        [cell updateCellWithModel:self.detailModel];
        return cell;
        
    }else if (indexPath.section == JYBOrderDetailTypeLogisMap){
        
        JYBOrderLogisMapViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderLogisMapViewCell class]) forIndexPath:indexPath];
        [cell updateCellWithModel:self.detailModel];
        return cell;
        
    }else if (indexPath.section == JYBOrderDetailTypeAddressInfo){
        JYBOrderDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailAddressCell class]) forIndexPath:indexPath];
        if (indexPath.row == 0) {
            [cell updateCellWithModel:[self.detailModel.box_address firstObject] isBox:YES box_no:self.detailModel.pick_no];
        }else{
            JYBOrderBoxAddressModel *subModel = [self.detailModel.shipment_address objectAtIndex:indexPath.row-1];
            [cell updateCellWithModel:subModel isBox:NO box_no:nil];
        }
        WeakObj(self);
        [cell setPhoneBlock:^(NSString *phone) {
            [selfWeak __phoneWithPhone:phone];
        }];
        
        [cell setNavBlock:^(JYBOrderBoxAddressModel *model) {
            [selfWeak __fetCurrentLocationWithModel:model];
        }];
        
        return cell;
        
    }else if (indexPath.section == JYBOrderDetailTypeBoxInfo){
        
        if (indexPath.row == 6) {
            JYBHomeOrderImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBHomeOrderImageCell class]) forIndexPath:indexPath];
            [cell updateCellWithArr:self.detailModel.box_img.mutableCopy];
            return cell;
        }else{
            JYBOrderDetailBoxInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailBoxInfoCell class]) forIndexPath:indexPath];
            if (indexPath.row == 0) {
                [cell updateCellWithIcon:@"dzf_icon_xx" title:@"箱型" value:[self __fetchBoxTypeWithType:self.detailModel.order_type] other:NO];
            }else if (indexPath.row == 1){
                [cell updateCellWithIcon:@"xx_icon_sj" title:@"装箱时间" value:self.detailModel.shipment_time other:NO];
            }else if (indexPath.row == 2){
                [cell updateCellWithIcon:@"xx_icon_sj" title:@"截关时间" value:self.detailModel.cutoff_time other:NO];
            }else if (indexPath.row == 3){
                [cell updateCellWithIcon:@"xx_icon_sj" title:@"提箱时间" value:self.detailModel.box_create_time other:NO];
            }else if (indexPath.row == 4){
                [cell updateCellWithIcon:@"ddxq_icon_xh" title:@"箱号" value:self.detailModel.box_no other:NO];
            }else{
                [cell updateCellWithIcon:@"ddxq_icon_fh" title:@"封号" value:self.detailModel.close_no other:NO];
            }
            return cell;
        }
        
        
    }else if (indexPath.section == JYBOrderDetailTypeMarkInfo){
        JYBOrderDetailMarkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailMarkInfoCell class]) forIndexPath:indexPath];
        [cell updateCellWithMark:self.detailModel.message];
        return cell;
    }else if (indexPath.section== JYBOrderDetailTypeCostInfo){
        
        JYBOrderDetailBoxInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailBoxInfoCell class]) forIndexPath:indexPath];
        [cell updateCellWithIcon:@"ddxq_icon_yf" title:@"运费" value:[NSString stringWithFormat:@"¥%@",self.detailModel.order_price] other:NO];
        return cell;
        
    }else if (indexPath.section== JYBOrderDetailTypeOtherCost){
        
        JYBOrderDetailBoxInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailBoxInfoCell class]) forIndexPath:indexPath];
        [cell updateCellWithIcon:@"ddxq_icon_yf" title:@"额外费用" value:[NSString stringWithFormat:@"¥%@",self.detailModel.other_price] other:YES];
        return cell;
        
    }else{
        JYBOrderDetailCostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBOrderDetailCostCell class]) forIndexPath:indexPath];
        [cell updataCellWithModel:self.detailModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == JYBOrderDetailTypeLogisUser) {
        
    }else if (indexPath.section == JYBOrderDetailTypeLogisInfo){
        JYBOrderLogisInfoVC *vc = [[JYBOrderLogisInfoVC alloc] init];
        vc.orderModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == JYBOrderDetailTypeLogisMap){
        JYBOrderMapVC *vc = [[JYBOrderMapVC alloc] init];
        vc.listModel = self.detailModel;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == JYBOrderDetailTypeAddressInfo){

    }else if (indexPath.section == JYBOrderDetailTypeBoxInfo){
        
    }else if (indexPath.section == JYBOrderDetailTypeMarkInfo){
        
    }else if (indexPath.section == JYBOrderDetailTypeCostInfo){
        
    }else if (indexPath.section == JYBOrderDetailTypeOtherCost){
        [self __turnToOtherCostSchVC];
        
    }else{
        
    }
    
    
}


- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
        _myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _myTableView.backgroundColor = RGB(240, 240, 240);
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedRowHeight = 100;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_myTableView registerClass:[JYBOrderDetailLogisUserCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailLogisUserCell class])];
        [_myTableView registerClass:[JYBOrderDetailLogisInfoCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailLogisInfoCell class])];
        [_myTableView registerClass:[JYBOrderDetailAddressCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailAddressCell class])];
        [_myTableView registerClass:[JYBOrderDetailBoxInfoCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailBoxInfoCell class])];
        [_myTableView registerClass:[JYBOrderDetailMarkInfoCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailMarkInfoCell class])];
        [_myTableView registerClass:[JYBOrderDetailCostCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderDetailCostCell class])];
        [_myTableView registerClass:[JYBHomeOrderImageCell class] forCellReuseIdentifier:NSStringFromClass([JYBHomeOrderImageCell class])];
        [_myTableView registerClass:[JYBOrderLogisMapViewCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderLogisMapViewCell class])];
        
        
        
    }
    return _myTableView;
}

- (void)commitBtnAction{
    
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录
            
            
            if (self.detailModel.order_status.integerValue == 20){
                JYBTiBoxDoneVC *vc = [[JYBTiBoxDoneVC alloc] init];
                vc.detailModel = self.detailModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if (self.detailModel.order_status.integerValue == 30){
                
                JYBOtherCostInputVC *vc = [[JYBOtherCostInputVC alloc] init];
                vc.detailModel = self.detailModel;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
            }
            
            
        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
            
            if (self.detailModel.order_status.integerValue == 30){
                [self __zhuangxianggongSureTake];
            }else{
                
            }
            
        }
    }else {
        //   未登录

        
    }
    

}

- (void)__zhuangxianggongSureTake{
        WeakSelf(weak)
         [[[JYBAlertView alloc] initWithTitle:@"确定货物已完成装车吗" message:nil cancelItem:@"取消" sureItem:@"确认" clickAction:^(NSInteger index) {
             if (index == 1){
                 [weak __sureTake];
             }
         }] show];
    
}

- (void)__sureTake{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:self.detailModel.order_id forKey:@"order_id"];
    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/Boxman/Order/completeBox" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChangeNotification" object:nil];
            [weak.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    
    
}


- (void)JYBOtherCostInputSuccess{
    [self __fetchOrderDetail];
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - SizeWidth(55) , kScreenW, SizeWidth(55))];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
        self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(10), SizeWidth(5), kScreenW - SizeWidth(20), SizeWidth(45))];
        self.commitBtn.backgroundColor = RGB(24, 141, 240);
        [self.commitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.commitBtn.layer.cornerRadius = 2;
        self.commitBtn.layer.masksToBounds = YES;
        [self.commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.commitBtn];
    }
    return _bottomView;
}

@end
