//
//  MeViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *phone;
}
@property (nonatomic, retain) UITableView *noUseTableView;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.noUseTableView];
    self.navigationView.hidden = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.noUseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.noUseTableView.scrollIndicatorInsets = self.noUseTableView.contentInset;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//        if (indexPath.row == 2) {
//            logo = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - 35, SizeHeight(12), 20, 20)];
//            logo.backgroundColor = [UIColor clearColor];
//            logo.image = [UIImage imageNamed:@"wd_icon_dh"];
//            [cell.contentView addSubview:logo];
//            [cell.contentView addSubview:self.phoneLab];
//        }
    }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 0) {
//        [self.navigationController pushViewController:[MyFavoritesViewController new] animated:YES];
//    }
//    if (indexPath.row == 1) {
//        [self.navigationController pushViewController:[DeviceCommandViewController new] animated:YES];
//    }
//    if (indexPath.row == 2) {
//        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//
//    }
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(325))];
            view.backgroundColor = [UIColor blueColor];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(60))];
            UIButton *logoutBtn = [[UIButton alloc] initWithFrame:FRAME(5, SizeHeight(10), kScreenW - 10, SizeHeight(50))];
            logoutBtn.backgroundColor = RGB(239, 240, 241);
            [logoutBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            logoutBtn.layer.masksToBounds = YES;
            [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            logoutBtn.layer.cornerRadius = SizeHeight(5);
            [view addSubview:logoutBtn];
            view;
        });
    }
    return _noUseTableView;
}

- (void)logout {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
