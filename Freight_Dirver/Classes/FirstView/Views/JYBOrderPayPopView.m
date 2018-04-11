//
//  JYBOrderPayPopView.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderPayPopView.h"
#import <YYKit.h>

@interface JYBOrderPayPopView ()

@property (nonatomic ,strong)UITableView *myTableView;

/** 弹窗 */
@property (nonatomic ,strong) UIView *alertView;

@property (nonatomic ,strong) UILabel *priceLab;

@property (nonatomic ,strong) UILabel *amountLab;

@property (nonatomic ,strong) UIButton *commitBtn;

@property (nonatomic,copy) JYBOrderPayPopViewResult myCall;

@end

@implementation JYBOrderPayPopView

- (instancetype)initWithPayAmount:(CGFloat)payamount totalAmount:(CGFloat)totalAmount ClickAction:(JYBOrderPayPopViewResult)action{
    if (self = [super init]) {
        [self setupWithPayAmount:payamount totalAmount:totalAmount ClickAction:action];
    }
    return self;
}

- (void)setupWithPayAmount:(CGFloat)payamount totalAmount:(CGFloat)totalAmount ClickAction:(JYBOrderPayPopViewResult)action{
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    
    self.alertView = [[UIView alloc]init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.frame = CGRectMake(0, kScreenH - SizeWidth(215), kScreenW, SizeWidth(215));
    [self addSubview:self.alertView];
    
    
    UILabel *priceTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, SizeWidth(20), kScreenW, SizeWidth(20))];
    priceTitleLab.textColor = RGB(52, 52, 52);
    priceTitleLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
    priceTitleLab.textAlignment = NSTextAlignmentCenter;
    priceTitleLab.text = @"待支付";
    [self.alertView addSubview:priceTitleLab];
    
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(0, priceTitleLab.bottom + SizeWidth(20), kScreenW, SizeWidth(25))];
    self.priceLab.textColor = RGB(252, 154, 46);
    self.priceLab.font = [UIFont boldSystemFontOfSize:SizeWidth(22)];
    self.priceLab.textAlignment = NSTextAlignmentCenter;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",payamount];
    [self.alertView addSubview:self.priceLab];
    
    self.amountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.priceLab.bottom + SizeWidth(45), kScreenW, SizeWidth(20))];
    self.amountLab.textColor = RGB(162, 162, 162);
    self.amountLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
    self.amountLab.textAlignment = NSTextAlignmentCenter;
    self.amountLab.text = [NSString stringWithFormat:@"钱包余额：¥%.2f",totalAmount];
    [self.alertView addSubview:self.amountLab];
    
    self.commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(15), self.amountLab.bottom + SizeWidth(10), kScreenW - SizeWidth(30), SizeWidth(45))];
    self.commitBtn.backgroundColor = RGB(252, 154, 46);
    [self.commitBtn setBackgroundImage:[UIImage imageWithColor:RGB(252, 154, 46)] forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:[UIImage imageWithColor:RGB(208, 208, 208)] forState:UIControlStateSelected];
    [self.commitBtn setTitle:@"支付" forState:UIControlStateNormal];
    self.commitBtn.titleLabel.font = [UIFont systemFontOfSize:SizeWidth(16)];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitBtn.layer.cornerRadius = 3;
    self.commitBtn.layer.masksToBounds = YES;
    [self.commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.commitBtn.selected = payamount > totalAmount;
    [self.alertView addSubview:self.commitBtn];
    
    self.myCall = action;
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handletap:)];
    ges.cancelsTouchesInView = NO;
    [self addGestureRecognizer:ges];
    
}

- (void)handletap:(UITapGestureRecognizer *)tapGes{
    if (tapGes.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tapGes locationInView:nil];
        if (![self.alertView pointInside:[self.alertView convertPoint:location fromView:self.alertView.window] withEvent:nil]) {
            [self dismiss];
        }
        
    }
    
}

- (void)commitBtnAction{
    
    if (self.myCall) {
        self.myCall();
    }
    
    [self dismiss];
    
}


#pragma mark - 弹出
-(void)show
{
    UIWindow *rootWindow = [[[UIApplication sharedApplication] delegate] window];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

-(void)creatShowAnimation
{
    self.alertView.frame = CGRectMake(0, kScreenH, kScreenW, SizeWidth(215));
    [UIView animateWithDuration:0.25 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.frame = CGRectMake(0, kScreenH - SizeWidth(215), kScreenW, SizeWidth(215));
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        self.alertView.frame = CGRectMake(0, kScreenH, kScreenW, SizeWidth(215));
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
