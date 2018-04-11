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

typedef enum : NSUInteger {
    JYBOrderDetailTypeLogisUser,
    JYBOrderDetailTypeLogisInfo,
    JYBOrderDetailTypeLogisMap,
    JYBOrderDetailTypeAddressInfo,
    JYBOrderDetailTypeBoxInfo,
    JYBOrderDetailTypeMarkInfo,
    JYBOrderDetailTypeCostInfo,
    JYBOrderDetailTypeOtherCost,
    JYBOrderDetailTypeOrderInfo,
    
} JYBOrderDetailType;

@interface JYBOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *myTableView;

@property (nonatomic ,strong)JYBOrderListModel *detailModel;

@property (nonatomic ,strong)JYBOrderDetailBottomView *bottomView;

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
    [HttpRequest postPath:@"/Driver/Order/orderDetail" params:dic resultBlock:^(id responseObject, NSError *error) {
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
    if (self.detailModel.order_status.integerValue == 0 || self.detailModel.order_status.integerValue == 10 || self.detailModel.order_status.integerValue == 40) {
        self.bottomView.hidden= NO;
        self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64 - SizeWidth(95));
        [self.bottomView updateBottomView:self.detailModel];
    }else{
        self.bottomView.hidden= YES;
        self.myTableView.frame = CGRectMake(0, 64, kScreenW, kScreenH - 64);
        
    }
    
}

- (void)more:(UIButton *)sender{
    [[[JYBAlertView alloc] initWithTitle:@"确定联系平台客服？" message:@"" cancelItem:@"取消" sureItem:@"确认" clickAction:^(NSInteger index) {
        if (index == 1) {
            NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",@""];
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
            return @"已进港待支付(额外费用待审核)";
            break;
            case 32:
            return @"已进港待支付(额外费用已拒绝)";
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


- (void)__turnToOtherCostSchVC{
    JYBOrderOtherCostVC *vc = [[JYBOrderOtherCostVC alloc] init];
    vc.orderModel = self.detailModel;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == JYBOrderDetailTypeLogisUser) {
        return ([NSString stringIsNilOrEmpty:self.detailModel.driver_id] || self.detailModel.order_status.integerValue == 0 || self.detailModel.order_status.integerValue == 10 || self.detailModel.order_status.integerValue == 60)?0:1;
    }else if (section == JYBOrderDetailTypeLogisInfo){
        return self.detailModel.logistics.count?1:0;
    }else if (section == JYBOrderDetailTypeLogisMap){
        return (self.detailModel.order_status.integerValue == 30 )?1:0;
    }else if (section == JYBOrderDetailTypeAddressInfo){
        return self.detailModel.shipment_address.count + 1;
    }else if (section == JYBOrderDetailTypeBoxInfo){
        return [self __fetchTypeBoxInfoNum];
    }else if (section == JYBOrderDetailTypeMarkInfo){
        return [NSString stringIsNilOrEmpty:self.detailModel.message]?0:1;
    }else if (section == JYBOrderDetailTypeCostInfo){
        return 1;
    }else if (section == JYBOrderDetailTypeOtherCost){
        return ([NSString stringIsNilOrEmpty:self.detailModel.other_price] || self.detailModel.other_price.floatValue <= 0)?0:1;
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
        return SizeWidth(150);
    }
    else if (indexPath.section == JYBOrderDetailTypeAddressInfo){
        return SizeWidth(110);
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
        return ([NSString stringIsNilOrEmpty:self.detailModel.driver_id] ||self.detailModel.order_status.integerValue == 0 || self.detailModel.order_status.integerValue == 10 || self.detailModel.order_status.integerValue == 60)?CGFLOAT_MIN:SizeWidth(10);
    }else if (section == JYBOrderDetailTypeLogisInfo){
        return CGFLOAT_MIN;
    }else if (section == JYBOrderDetailTypeLogisMap){
        return (self.detailModel.logistics.count || self.detailModel.order_status.integerValue == 30)?SizeWidth(10):CGFLOAT_MIN;
    }else if (section == JYBOrderDetailTypeAddressInfo){
        return SizeWidth(10);
    }else if (section == JYBOrderDetailTypeBoxInfo){
        return SizeWidth(10);
    }else if (section == JYBOrderDetailTypeMarkInfo){
        return [NSString stringIsNilOrEmpty:self.detailModel.message]?CGFLOAT_MIN:SizeWidth(10);
    }else if (section== JYBOrderDetailTypeCostInfo){
        return SizeWidth(10);
    }else if (section== JYBOrderDetailTypeOtherCost){
        return ([NSString stringIsNilOrEmpty:self.detailModel.other_price] || self.detailModel.other_price.floatValue <= 0)?CGFLOAT_MIN:SizeWidth(10);
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
                [cell updateCellWithIcon:@"xx_icon_sj" title:@"截箱时间" value:self.detailModel.cutoff_time other:NO];
            }else if (indexPath.row == 3){
                [cell updateCellWithIcon:@"xx_icon_sj" title:@"提箱时间" value:self.detailModel.cutoff_time other:NO];
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
//        JYBOrderMapVC *vc = [[JYBOrderMapVC alloc] init];
//        vc.listModel = self.detailModel;
//        [self.navigationController pushViewController:vc animated:YES];
        
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
//        [_myTableView registerClass:[JYBOrderLogisMapViewCell class] forCellReuseIdentifier:NSStringFromClass([JYBOrderLogisMapViewCell class])];
        
        
        
    }
    return _myTableView;
}

- (JYBOrderDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[JYBOrderDetailBottomView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height -  SizeWidth(95), kScreenW, SizeWidth(95))];
//        WeakSelf(weak)
//        [_bottomView setScheBlock:^{
//            [weak __turnToOtherCostSchVC];
//        }];
//        [_bottomView setPayBlock:^(JYBOrderDetailBottomType type) {
//            if (type == JYBOrderDetailBottomTypeCancel) {
//                [weak __cancelOrder];
//            }else{
//                [weak __orderPay:type];
//            }
//        }];
    }
    return _bottomView;
}

//- (UIView *)bottomView{
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - SizeWidth(50) , kScreenW, SizeWidth(50))];
//        _bottomView.backgroundColor = [UIColor whiteColor];
//
//        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(10), SizeWidth(5), kScreenW - SizeWidth(20), SizeWidth(40))];
//        commitBtn.backgroundColor = RGB(24, 141, 240);
//        [commitBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        commitBtn.layer.cornerRadius = 2;
//        commitBtn.layer.masksToBounds = YES;
//        [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:commitBtn];
//    }
//    return _bottomView;
//}

@end
