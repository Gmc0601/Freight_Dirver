//
//  SystemMessageViewController.m
//  Freight_Company
//
//  Created by cc on 2018/1/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemCellTableViewCell.h"
#import <MJExtension.h>
//#import "JYBOrderDetailVC.h"

@implementation SystemModel

@end

@interface SystemMessageViewController ()<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    [self.view addSubview:self.noUseTableView];
}

- (void)getdata {
    [HttpRequest postPath:@"/Home/User/msglist" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSLog(@"???%@", responseObject);
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSDictionary *data = datadic[@"data"];
            self.dataArr = [SystemModel mj_objectArrayWithKeyValuesArray:data];
            [self.noUseTableView reloadData];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)resetFather {
    [self setCustomerTitle:@"系统消息"];
//    self.titleLab.text = @"系统消息";
//    self.rightBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%d", indexPath.row];
    SystemCellTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SystemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    [cell update:self.dataArr[indexPath.section]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(114);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SizeHeight(25);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(25))];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 5, kScreenW, SizeHeight(15))];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentCenter;
    SystemModel *model = self.dataArr[section];
    lab.text = model.create_time;
    lab.textColor = UIColorFromHex(0x999999);
    
    [headerView addSubview:lab];
    
    
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //   t
    SystemModel *model = self.dataArr[indexPath.section];
//    JYBOrderDetailVC *vc = [[JYBOrderDetailVC alloc] init];
//    vc.order_id = model.order_id;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        
    }
    return _noUseTableView;
}
@end
