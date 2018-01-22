//
//  MessageViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MessageViewController.h"
#import <YYKit.h>
#import "SystemMessageViewController.h"

@interface MessageViewController ()<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    [self.view addSubview:self.noUseTableView];
}

- (void)navigation {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"nav_icon_kf"] action:@selector(backAction)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:view.frame];
    img.image = [UIImage imageNamed:@"icon_jyb"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:img];
    self.navigationItem.titleView = view;
}

- (void)backAction {
//    [self.navigationController pushViewController:[NextViewController new] animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section ? 3 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%d", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@"xxzx_icon_xtxx"];
            cell.textLabel.text = @"系统消息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            UIButton *message , *callBtn;
            message = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(260), SizeHeight(24), SizeWidth(34), SizeWidth(34))];
            message.backgroundColor = [UIColor clearColor];
            [message setImage:[UIImage imageNamed:@"ddxq_icon_lt_68 (1)"] forState:UIControlStateNormal];
            message.tag = 100 + indexPath.row;
            [message addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            message.centerY = cell.contentView.centerY;
            [cell.contentView addSubview:message];
            
            callBtn = [[UIButton alloc] initWithFrame:FRAME(message.right + SizeWidth(15), SizeHeight(24), SizeWidth(34), SizeWidth(34))];
            callBtn.backgroundColor = [UIColor clearColor];
            callBtn.tag = 1000 + indexPath.row;
            [callBtn setImage:[UIImage imageNamed:@"ddxq_icon_dh_68 (1)"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            callBtn.centerY = cell.contentView.centerY;
            [cell.contentView addSubview:callBtn];
            cell.imageView.image = [UIImage imageNamed:@"xxzx_icon_96 (1)"];
            cell.textLabel.text = @"你好";
        }
        [cell.imageView sizeToFit];
        
        
    }
    return cell;
}

- (void)btnClick:(UIButton *)sender {
    int tag = sender.tag;
    
    if (tag < 1000) {
        //  message
    }else {
        //  call
    }
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(82);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section ? 0.001 :SizeHeight(10);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(105))];
    headerView.backgroundColor = RGB(239, 240, 241);
    
    
    return headerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[SystemMessageViewController new] animated:YES];
    }
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
    }
    return _noUseTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
