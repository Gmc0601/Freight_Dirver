//
//  ChoseMembersViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ChoseMembersViewController.h"
#import "LoginViewController.h"

@interface ChoseMembersViewController ()
@property (weak, nonatomic) IBOutlet UIView *driverView;
@property (weak, nonatomic) IBOutlet UIView *connactView;
@property (weak, nonatomic) IBOutlet UIImageView *driverLab;

@property (weak, nonatomic) IBOutlet UILabel *connactLab;

@end

@implementation ChoseMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    [self.leftBar setImage:[UIImage imageNamed:@"dl_icon_sc"] forState:UIControlStateNormal];
    self.line.hidden = YES;
    self.rightBar.hidden = YES;
    
    self.driverView.layer.masksToBounds = YES;
    self.driverView.layer.borderWidth = 1;
    self.driverView.layer.borderColor = [UIColorFromHex(0xE3E3E3) CGColor];
    
    self.connactView.layer.masksToBounds = YES;
    self.connactView.layer.borderWidth = 1;
    self.connactView.layer.borderColor = [UIColorFromHex(0xE3E3E3) CGColor];
    
}


- (void)back:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)dirverView:(id)sender {
    [self jump:User_Driver];
}
- (IBAction)connactClick:(id)sender {
    [self jump:User_Worker];
}
- (void)jump:(LoginUserType *)type {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
