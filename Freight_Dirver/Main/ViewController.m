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
    
    //     客服电话
    [HttpRequest postPath:@"/Home/Public/kfdh" params:nil resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            NSString *data = datadic[@"data"];
            [ConfigModel saveString:data forKey:Servicephone];
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    TBTabBarController *_tabBC = [[TBTabBarController alloc] init];
    [self addChildViewController:_tabBC];
    [self.view addSubview:_tabBC.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
