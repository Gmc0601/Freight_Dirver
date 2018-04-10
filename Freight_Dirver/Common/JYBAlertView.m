//
//  JYBAlertView.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBAlertView.h"
// 各个栏目之间的距离
#define MKPSpace 10.0

@interface JYBAlertView  ()

/** 弹窗 */
@property(nonatomic,strong) UIView *alertView;
/** title */
@property(nonatomic,strong) UILabel *titleLbl;
/** 内容 */
@property(nonatomic,strong) UILabel *msgLbl;
/** 确认按钮 */
@property(nonatomic,strong) UIButton *sureBtn;
/** 取消按钮 */
@property(nonatomic,strong) UIButton *cancleBtn;
/** frame_bottom */
@property(nonatomic,assign) CGFloat fraBottom;
/** 回调 */
@property (nonatomic,copy) CustomAlertResult myCall;

@end


@implementation JYBAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelItem:(NSString *)cancelITem sureItem:(NSString *)sureItem clickAction:(CustomAlertResult)action{
    if (self = [super init]) {
        [self setupUI:title message:message cancelItem:cancelITem sureItem:sureItem clickAction:action];
    }
    return self;
}

- (void)setupUI:(NSString *)title message:(NSString *)message cancelItem:(NSString *)cancelItem sureItem:(NSString *)sureItem clickAction:(CustomAlertResult)action{
    
    self.fraBottom = 0;
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.alertView = [[UIView alloc]init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 5.0;
    self.alertView.frame = CGRectMake(0, 0, kLgCustomAlertW, 100);
    self.alertView.layer.position = self.center;
    self.alertView.clipsToBounds = YES;
    
    if (![NSString stringIsNilOrEmpty:title]) {
        self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(MKPSpace, 3*MKPSpace, kLgCustomAlertW-MKPSpace, 20)];
        self.titleLbl.font = [UIFont systemFontOfSize:17];
        self.titleLbl.textColor = RGB(52, 52, 52);
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.numberOfLines = 0;
        self.titleLbl.text = title;
        [self.titleLbl sizeToFit];
        [self.alertView addSubview:self.titleLbl];
        
        CGFloat titleW = self.titleLbl.bounds.size.width;
        CGFloat titleH = self.titleLbl.bounds.size.height;
        self.titleLbl.frame = CGRectMake((kLgCustomAlertW-titleW)/2, self.fraBottom + 3*MKPSpace, titleW, titleH);
        self.fraBottom = CGRectGetMaxY(self.titleLbl.frame);
    }
    
    if (![NSString stringIsNilOrEmpty:message]) {
        
        self.msgLbl = [[UILabel alloc] initWithFrame:CGRectMake(MKPSpace, self.fraBottom+ 2*MKPSpace, kLgCustomAlertW-2*MKPSpace, 20)];
        self.msgLbl.font = [UIFont systemFontOfSize:14];
        self.msgLbl.textColor = RGB(52, 52, 52);
        self.msgLbl.textAlignment = NSTextAlignmentCenter;
        self.msgLbl.numberOfLines = 0;
        self.msgLbl.text = message;
        [self.msgLbl sizeToFit];
        [self.alertView addSubview:self.msgLbl];
        
        CGFloat msgW = self.msgLbl.bounds.size.width;
        CGFloat msgH = self.msgLbl.bounds.size.height;
        self.msgLbl.frame = CGRectMake((kLgCustomAlertW-msgW)/2, self.fraBottom + 2*MKPSpace, msgW, msgH);
        self.fraBottom = CGRectGetMaxY(self.msgLbl.frame);
        
    }
    
    //两个按钮
    if (cancelItem && sureItem) {
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.cancleBtn.frame = CGRectMake(20, self.fraBottom + 20, (kLgCustomAlertW - 60)/2, 45);
        self.cancleBtn.backgroundColor = RGB(242, 242, 242);
        [self.cancleBtn setTitle:cancelItem forState:UIControlStateNormal];
        [self.cancleBtn setTitleColor:RGB(52, 52, 52) forState:UIControlStateNormal];
        self.cancleBtn.tag = 0;
        [self.cancleBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancleBtn];
        
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame = CGRectMake((kLgCustomAlertW - 60)/2 + 40, self.fraBottom + 20, (kLgCustomAlertW - 60)/2, 45);
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.sureBtn setTitle:sureItem forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = RGB(24, 141, 240);
        self.sureBtn.tag = 1;
        [self.sureBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.sureBtn];
        self.fraBottom = CGRectGetMaxY(self.sureBtn.frame);
        
    }
    

    //计算高度
    CGFloat alertHeight = self.fraBottom + 15;
    self.alertView.frame = CGRectMake(0, 0, kLgCustomAlertW, alertHeight);
    self.alertView.layer.position = self.center;
    [self addSubview:self.alertView];
    
    self.myCall = action;
    
    
}

#pragma mark - 回调
- (void)buttonEvent:(UIButton *)sender
{
    if (self.myCall) {
        self.myCall(sender.tag);
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        self.alertView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
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
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.80, 0.80);
    [UIView animateWithDuration:0.25 delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
