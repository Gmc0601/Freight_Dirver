//
//  JYBOrderSingleVC.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderSingleVC.h"
#import "JYBHomeOrderListCell.h"
#import "JYBOrderPayPopView.h"
#import "JYBOrderDetailVC.h"
#import "JYBOrderListModel.h"
#import "TBRefresh.h"
#import <YYKit.h>
@interface JYBOrderSingleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)UITableView *myTableView;

@property (nonatomic ,strong)NSMutableArray *dataArr;

@property (nonatomic ,assign)NSInteger  currentPage;
@end

@implementation JYBOrderSingleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 1;
    [self.view addSubview:self.myTableView];
    
    [self __fetchOrderList];
}

- (void)__fetchOrderList{

    NSString *status;
    if (self.type == JYBOrderTypeWaitTi) {
        status = @"20";
    }else if (self.type == JYBOrderTypeTransing){
        status = @"30";
    }else{
        status = @"50";
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:status forKey:@"order_status"];
    [dic addUnEmptyString:[NSString stringWithFormat:@"%ld",self.currentPage] forKey:@"page"];
    [dic addUnEmptyString:@"10" forKey:@"size"];

    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/Driver/Order/orderList" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        [weak.myTableView.header endHeadRefresh];
        [weak.myTableView.footer endFooterRefreshing];
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            if (weak.currentPage == 1) {
                [weak.dataArr removeAllObjects];
            }
            for (NSDictionary *subDic in datadic[@"data"]) {
                JYBOrderListModel *model = [JYBOrderListModel modelWithDictionary:subDic];
                [weak.dataArr addObject:model];
            }
            [weak.myTableView reloadData];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SizeWidth(190);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JYBHomeOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JYBHomeOrderListCell class]) forIndexPath:indexPath];
    JYBOrderListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    [cell udpateCellWithModel:model];
    WeakObj(self);
    [cell setListBlock:^(JYBHomeOrderListAction action,JYBOrderListModel *listModel) {
        if (action == JYBHomeOrderListActionContact) {
            [selfWeak __phoneWithModel:listModel];
        }else if (action == JYBHomeOrderListActionOrder){

        }else{

        }
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JYBOrderListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    JYBOrderDetailVC *vc = [[JYBOrderDetailVC alloc] init];
    vc.order_id = model.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)__phoneWithModel:(JYBOrderListModel *)listModel{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认拨打\n%@",listModel.driver_phone] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phoneStr = [NSString stringWithFormat:@"tel://%@",listModel.driver_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, self.view.bounds.size.height - 49) style:UITableViewStyleGrouped];
        _myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _myTableView.backgroundColor = RGB(246, 246, 246);
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        WeakObj(self);
        [_myTableView addRefreshHeaderWithBlock:^{
            selfWeak.currentPage = 1;
            [selfWeak __fetchOrderList];
        }];
        [_myTableView addRefreshFootWithBlock:^{
            selfWeak.currentPage +=1;
            [selfWeak __fetchOrderList];
        }];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_myTableView registerClass:[JYBHomeOrderListCell class] forCellReuseIdentifier:NSStringFromClass([JYBHomeOrderListCell class])];
    }
    return _myTableView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
