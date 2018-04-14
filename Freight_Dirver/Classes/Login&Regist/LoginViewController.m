
//
//  LoginViewController.m
//  BaseProject
//
//  Created by cc on 2017/12/12.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
#import "CCWebViewViewController.h"
#import <MJExtension.h>
#import "PerfectInfoViewController.h"
#import "ReviewViewController.h"
#import "AddInfoModel.h"
#import <Hyphenate/Hyphenate.h>
#import "ViewController.h"

@implementation UserModel


@end

@implementation CompanyInfo


@end
@interface LoginViewController (){
    NSString *loginUrl , *codeUrl;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUrl];
    self.line.hidden= YES;
    self.rightBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view1.layer.masksToBounds = YES;
    self.view2.layer.masksToBounds = YES;
    self.view1.layer.borderWidth = 1;
    self.view2.layer.borderWidth = 1;
    self.view1.layer.borderColor = [UIColorFromHex(0xe3e3e3) CGColor];
    self.view2.layer.borderColor = [UIColorFromHex(0xe3e3e3) CGColor];
    [self.leftBar setImage:[UIImage imageNamed:@"nav_icon_fh"] forState:UIControlStateNormal];
    [self.phoneText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    [self.codeText addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.codeText.keyboardType = UIKeyboardTypeNumberPad;
    
}

- (void)initUrl {
//     司机端
    if (self.type == User_Driver) {
        loginUrl = @"/Driver/Public/login";
        codeUrl = @"/Driver/Public/sendCode";
    }
//    装箱工端
    if (self.type == User_Worker) {
        loginUrl = @"/DBoxman/Public/login";
        codeUrl = @"/Boxman/Public/sendCode";
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.leftBar.hidden = NO;
    
}

- (void)back:(UIButton *)sender {
   
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)textchange {

}


- (IBAction)codeBtnClick:(id)sender {
    
    if (self.phoneText.text.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入11位有效手机号" andView:nil];
        return;
    }
    WeakSelf(weak);
    NSDictionary *dic = @{
                          @"phone" : self.phoneText.text,
                          };
    [HttpRequest postPath:codeUrl params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            [ConfigModel mbProgressHUD:@"发送成功" andView:nil];
            __block int timeout=59 ; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        
//                        [weak.codeBtn setTitleColor:UIColorFromHex(0x666666) forState:UIControlStateNormal];
                        [weak.codeBtn setTitle:@"重获验证码" forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = YES;
                    });
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
                        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%@s)",strTime] forState:UIControlStateNormal];
                        weak.codeBtn .userInteractionEnabled = NO;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }

    }];
    
   
}
- (IBAction)loginBtnClick:(id)sender {
    
    
    if (self.phoneText.text.length != 11) {
        [ConfigModel mbProgressHUD:@"请输入11位手机号" andView:nil];
        return;
    }
    
    
    if (self.codeText.text.length != 4) {
        [ConfigModel mbProgressHUD:@"请输入4位验证码" andView:nil];
        return;
    }
    
    
    if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
        NSDictionary *dic = @{
                              @"phone" :self.phoneText.text,
                              @"vcode" : self.codeText.text
                              };
        
        [HttpRequest postPath:loginUrl params:dic resultBlock:^(id responseObject, NSError *error) {
            
            
            //  登录环信
           
            
            if([error isEqual:[NSNull null]] || error == nil){
                NSLog(@"success");
            }
            NSDictionary *datadic = responseObject;
            if ([datadic[@"success"] intValue] == 1) {
                NSDictionary *data = datadic[@"data"];
                UserModel *user = [UserModel mj_objectWithKeyValues:data];
                EMError *error = nil;
                NSString *userId = [NSString stringWithFormat:@"d%@", user.driver_id];
                error = [[EMClient sharedClient] registerWithUsername:userId password:ChatPWD];
                error = [[EMClient sharedClient] loginWithUsername:userId password:ChatPWD];
                if (IsNULL(user.car_no) || [user.car_no isEqualToString:@""]) {
                    //   车牌号为空 去填写资料
                    PerfectInfoViewController *vc = [[PerfectInfoViewController alloc] init];
                    vc.type = AddOne;
                    AddInfoModel *model = [[AddInfoModel alloc] init];
                    model.driver_id =  user.driver_id;
                    model.fleet_id = user.fleet_id;
                    vc.model =  model;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    if ([user.status intValue] == 0) {
                        //  待审核
                        ReviewViewController *vc = [[ReviewViewController alloc] init];
                        vc.type =  Reviewing;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else if([user.status intValue] == 1){
                        //  审核通过
                        [ConfigModel saveString:user.driver_id forKey:DriverId];
                        [ConfigModel saveBoolObject:YES forKey:IsLogin];
                        [self presentViewController:[ViewController new] animated:YES completion:nil];
//                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else {
                        //  审核失败
                        ReviewViewController *vc = [[ReviewViewController alloc] init];
                        vc.type =  ReviewError;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
            }else {
                NSString *str = datadic[@"msg"];
                [ConfigModel mbProgressHUD:str andView:nil];
            }
        }];
    }
    
    if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
        //   装箱工  登录
        
    }
    
    
}

- (IBAction)userAgreeClick:(id)sender {
    CCWebViewViewController *vc = [[CCWebViewViewController alloc] init];
    vc.titlestr = @"注册协议";
    vc.UrlStr = @"http://116.62.142.20/Public/zcxy";
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
