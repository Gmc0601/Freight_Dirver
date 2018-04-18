//
//  BoxmanMyCenterViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/4/18.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "BoxmanMyCenterViewController.h"
#import <YYKit.h>
#import "UserInfoViewController.h"
#import <MJExtension.h>
#import "CCWebViewViewController.h"

@implementation BoxUserModel

@end

@interface BoxmanMyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *phone, *headimageStr, *nickNameStr, *UserAgreeContent;
}

@property (nonatomic, retain) UITableView *noUseTableView;
@property (nonatomic, retain) NSArray *titleArr, *picArr;
@property (nonatomic, retain) UIImageView *headImage;
@property (nonatomic, retain) UILabel *nickNamelab;

@end

@implementation BoxmanMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationView.hidden = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.noUseTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.leftBar];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getdate];
}

- (void)getdate {
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
    [HttpRequest postPath:@"/Boxman/Boxman/getBoxmanInfo" params:nil resultBlock:^(id responseObject, NSError *error) {
        @strongify(self)
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            NSDictionary *data = datadic[@"data"];
            BoxUserModel *user = [BoxUserModel mj_objectWithKeyValues:data];
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:user.boxman_face] placeholderImage:[UIImage imageNamed:@"wd_icon_140 (1)"]];
            self.nickNamelab.text =  user.boxman_name;
            headimageStr = user.boxman_face;
            nickNameStr = user.boxman_name;
            [self.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
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
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = phone;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self call];
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

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(180))];
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
    
    self.nickNamelab = [[UILabel alloc] initWithFrame:FRAME(0, self.headImage.bottom + SizeHeight(12), kScreenW, SizeHeight(15))];
    self.nickNamelab.backgroundColor = [UIColor clearColor];
    self.nickNamelab.textAlignment = NSTextAlignmentCenter;
    self.nickNamelab.textColor = [UIColor whiteColor];
    self.nickNamelab.text = @"张菊花";
    [view addSubview:self.nickNamelab];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.headImage.frame];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

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
