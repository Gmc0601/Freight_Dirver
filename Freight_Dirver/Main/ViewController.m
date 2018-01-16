//
//  ViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ViewController.h"
#import "TBTabBarController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TBTabBarController *_tabBC = [[TBTabBarController alloc] init];
    [self addChildViewController:_tabBC];
    [self.view addSubview:_tabBC.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
