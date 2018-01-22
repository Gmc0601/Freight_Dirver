//
//  MeViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MeViewController.h"
#import "ChoseMembersViewController.h"
#import "TrasformViewController.h"
#import "UserInfoViewController.h"
#import <YYKit.h>
#import "HeadInfoView.h"
#import "CCWebViewViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *phone;
}
@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSArray *titleArr, *picArr;
@property (nonatomic, retain) UIImageView *headImage;
@property (nonatomic, retain) UILabel *nickNamelab, *scorelab, *logolab;

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
//    ChoseMembersViewController *vc = [[ChoseMembersViewController alloc] init];
//    vc.backBlock = ^{
//        self.tabBarController.selectedIndex = 0;
//    };
//
//    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:na animated:YES completion:nil];
    
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
    }
    NSString *imagestr = self.picArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imagestr];
    [cell.imageView sizeToFit];

    cell.textLabel.text = self.titleArr[indexPath.row];
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"0571—110110110";
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
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[TrasformViewController new] animated:YES];
    }
    if (indexPath.row == 1) {
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];    }
    if (indexPath.row == 2) {
        CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
        vc.titlestr = @"用户协议";
        vc.UrlStr = @"http://116.62.142.20/Public/zcxy";
        [self.navigationController pushViewController:vc animated:YES];

    }
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(325))];
            view.backgroundColor = UIColorFromHex(0x018BF2);
            [self addheadView:view];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeight(60))];
            UIButton *logoutBtn = [[UIButton alloc] initWithFrame:FRAME(10, SizeHeight(10), kScreenW - 20, SizeHeight(50))];
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

- (void)addheadView:(UIView *)view {
    
    self.headImage = [[UIImageView alloc] initWithFrame:FRAME(0, SizeHeight(60), SizeWidth(70), SizeWidth(70))];
    self.headImage.backgroundColor = [UIColor clearColor];
    self.headImage.image = [UIImage imageNamed:@"wd_icon_140 (1)"];
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = SizeWidth(35);
    self.headImage.centerX = view.centerX;
    [view addSubview:self.headImage];

    self.nickNamelab = [[UILabel alloc] initWithFrame:FRAME(0, self.headImage.bottom + SizeHeight(12), kScreenW/2 + SizeWidth(10), SizeHeight(15))];
    self.nickNamelab.backgroundColor = [UIColor clearColor];
    self.nickNamelab.textAlignment = NSTextAlignmentRight;
    self.nickNamelab.textColor = [UIColor whiteColor];
    self.nickNamelab.text = @"张菊花";
    [view addSubview:self.nickNamelab];
    
    self.scorelab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2 + SizeWidth(10), self.headImage.bottom + SizeHeight(15), kScreenW/2 - SizeWidth(10), SizeHeight(12))];
    self.scorelab.textColor = UIColorFromHex(0xFF9A14);
    self.scorelab.font = [UIFont systemFontOfSize:13];
    self.scorelab.text = @"5.0分";
    self.scorelab.backgroundColor = [UIColor clearColor];
    [view addSubview:self.scorelab];
    
    self.logolab = [[UILabel alloc] initWithFrame:FRAME(0, self.nickNamelab.bottom + SizeHeight(10), kScreenW, SizeHeight(15))];
    self.logolab.backgroundColor = [UIColor clearColor];
    self.logolab.textColor = [UIColor whiteColor];
    self.logolab.font = [UIFont systemFontOfSize:13];
    self.logolab.textAlignment = NSTextAlignmentCenter;
    self.logolab.text = @"集运帮";
    [view addSubview:self.logolab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.headImage.frame];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    
    HeadInfoView *info1 = [[HeadInfoView alloc] initWithFrame:FRAME(0, SizeHeight(215), kScreenW, SizeHeight(55)) title1:@"累计接单(单)" title2:@"累计收入(元)" color:UIColorFromHex(0x1C9BFA)];
    
    [view addSubview:info1];
    
    HeadInfoView *info2 = [[HeadInfoView alloc] initWithFrame:FRAME(0, SizeHeight(215 + 55), kScreenW, SizeHeight(55)) title1:@"本月接单(单)" title2:@"本月收入(元)" color:UIColorFromHex(0x3CA9FB)];
    [view addSubview:info2];
    
}

- (void)userInfoClick {
    [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
}

- (void)logout {
        ChoseMembersViewController *vc = [[ChoseMembersViewController alloc] init];
        vc.backBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
    
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"收支明细", @"平台客服", @"用户协议"];
    }
    return _titleArr;
}
- (NSArray *)picArr {
    if (!_picArr) {
        _picArr = @[@"wd_icon_szmx", @"wd_icon_ptkf", @"wd_icon_yhxy"];
    }
    return _picArr;
}



@end
