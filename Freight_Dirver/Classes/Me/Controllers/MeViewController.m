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
#import <MJExtension.h>
#import "LoginViewController.h"
#import <UIImageView+WebCache.h>
#import "TrasformViewController.h"

@interface MeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSString *phone;
    NSString *UserAgreeContent;
    NSString *headimageStr, *nickNameStr;
    BOOL JIYunBang;
}
@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSArray *titleArr, *picArr;
@property (nonatomic, retain) UIImageView *headImage;
@property (nonatomic, retain) UILabel *nickNamelab, *scorelab, *logolab;
@property (nonatomic, strong) HeadInfoView *info1, *info2;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JIYunBang = NO;
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
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        ChoseMembersViewController *vc = [[ChoseMembersViewController alloc] init];
        vc.backBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    [self getData];
}

- (void)getData {
    
    //     客服电话
    [HttpRequest postPath:@"/Home/Public/kfdh" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            NSString *data = datadic[@"data"];
            phone = data;
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    //     用户注册协议
    [HttpRequest postPath:@"/Home/Public/yhxy" params:nil resultBlock:^(id responseObject, NSError *error) {
        
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSString *data = datadic[@"data"];
            UserAgreeContent = data;
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    @weakify(self)
    [HttpRequest postPath:@"/Driver/Driver/driverInfo" params:nil resultBlock:^(id responseObject, NSError *error) {
        NSLog(@"%@", responseObject);
        @strongify(self)
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            NSDictionary *data = datadic[@"data"];
             UserModel *user = [UserModel mj_objectWithKeyValues:data];
            
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.driver_face] placeholderImage:[UIImage imageNamed:@"wd_icon_140 (1)"]];
            self.nickNamelab.text =  user.driver_name;
            self.logolab.text = user.fleet_name;
            self.scorelab.text = [NSString stringWithFormat:@"%@分", user.evel_score];
            if ([user.fleet_name isEqualToString:@"集运邦"]) {
                self.titleArr = @[@"收支明细", @"平台客服", @"用户协议"];
                self.picArr= @[@"wd_icon_szmx",@"wd_icon_ptkf", @"wd_icon_yhxy"];
                [self.noUseTableView reloadData];
                JIYunBang = YES;
            }
            [ConfigModel saveString:user.fleet_id forKey:FleetId];
            headimageStr = user.driver_face;
            nickNameStr = user.driver_name;
            self.info1.infoLab1.text = user.order_count;
            self.info1.infolab2.text = user.total_price;
            self.info2.infoLab1.text = user.month_order;
            self.info2.infolab2.text = user.month_price;
            
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeight(55) - 1, kScreenW, 1)];
        line.backgroundColor = UIColorHex(0xe3e3e3);
        [cell.contentView addSubview:line];
    }
    NSString *imagestr = self.picArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imagestr];
    [cell.imageView sizeToFit];

    cell.textLabel.text = self.titleArr[indexPath.row];
    
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = phone;
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
        if (JIYunBang) {
            //   收支明细
            TrasformViewController *vc = [[TrasformViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self call];
        }
        
    }
   else if (indexPath.row == 1) {
        if (JIYunBang) {
            [self call];
        }else {
            [self useragreement];
        }
        
    }else {
        [self useragreement];
    }

}

- (void)call {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)useragreement {
    CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
    vc.titlestr = @"用户协议";
    vc.content = UserAgreeContent;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.info1 = info1;
    [view addSubview:info1];
    
    HeadInfoView *info2 = [[HeadInfoView alloc] initWithFrame:FRAME(0, SizeHeight(215 + 55), kScreenW, SizeHeight(55)) title1:@"本月接单(单)" title2:@"本月收入(元)" color:UIColorFromHex(0x3CA9FB)];
    self.info2 = info2;
    [view addSubview:info2];
}

- (void)userInfoClick {
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    vc.headImageStr = headimageStr;
    vc.nickNameStr = nickNameStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)logout {
    [ConfigModel saveBoolObject:NO forKey:IsLogin];
    [ConfigModel saveBoolObject:NO forKey:DriverLogin];
    [ConfigModel saveBoolObject:NO forKey:WorkLogin];
    UnloginReturn
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[ @"平台客服", @"用户协议"];
    }
    return _titleArr;
}
- (NSArray *)picArr {
    if (!_picArr) {
        _picArr = @[ @"wd_icon_ptkf", @"wd_icon_yhxy"];
    }
    return _picArr;
}



@end
