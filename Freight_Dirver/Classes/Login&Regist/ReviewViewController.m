//
//  ReviewViewController.m
//  Freight_Company
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ReviewViewController.h"
#import "NODataView.h"
#import "PerfectInfoViewController.h"



@interface ReviewViewController ()

@property (nonatomic, retain) NODataView *nodataView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLav;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"审核进度";
    self.rightBar.hidden = YES;
    
    
    if (self.type == Reviewing) {
        self.icon.hidden = YES;
        self.titleLav.hidden = YES;
        self.subTitleLab.hidden = YES;
        self.contentLab.hidden = YES;
        self.resetBtn.hidden = YES;
        [self.view addSubview:self.nodataView];
    }
    
    
}
- (IBAction)resetInfo:(id)sender {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(100), kScreenH/2, SizeWidth(200), SizeHeight(110)) withimage:@"icon_shz" andtitle:@"信息审核中，请耐心等待"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}


@end
