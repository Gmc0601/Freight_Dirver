//
//  ReviewViewController.m
//  Freight_Company
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "ReviewViewController.h"
#import "NODataView.h"

@interface ReviewViewController ()

@property (nonatomic, retain) NODataView *nodataView;

@end

@implementation ReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"审核进度";
    self.rightBar.hidden = YES;
}
- (IBAction)resetInfo:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



- (NODataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[NODataView alloc] initWithFrame:FRAME(kScreenW/2 - SizeWidth(65), kScreenH/2, SizeWidth(130), SizeHeight(110)) withimage:@"icon_shz4" andtitle:@"信息审核中，请耐心等待"];
        _nodataView.clickBlock = ^{
        };
    }
    return _nodataView;
}


@end
