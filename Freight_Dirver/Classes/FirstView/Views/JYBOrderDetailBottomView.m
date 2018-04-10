//
//  JYBOrderDetailBottomView.m
//  Freight_Company
//
//  Created by ToneWang on 2018/3/18.
//  Copyright © 2018年 cc. All rights reserved.
// 40 + 50 + 5 +20

#import "JYBOrderDetailBottomView.h"

@interface JYBOrderDetailBottomView ()

@property (nonatomic ,strong)UIView     *backView;

@property (nonatomic ,strong)UIButton    *commitBtn;

@property (nonatomic ,strong)UILabel    *desLab;

@property (nonatomic ,strong)UILabel    *priceTitleLab;

@property (nonatomic ,strong)UILabel    *priceLab;

@property (nonatomic ,strong)UIButton   *scheBtn;

@property (nonatomic ,strong)JYBOrderListModel *listModel;
@end

@implementation JYBOrderDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.desLab];
    [self.backView addSubview:self.priceTitleLab];
    [self.backView addSubview:self.priceLab];
    [self.backView addSubview:self.scheBtn];
    [self.backView addSubview:self.commitBtn];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SizeWidth(20));
        make.left.bottom.right.equalTo(self);
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.backView);
        make.height.mas_equalTo(SizeWidth(50));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - SizeWidth(30));
        make.right.equalTo(self.backView).offset(-SizeWidth(15));
        make.top.equalTo(self.desLab.mas_bottom);
        make.height.mas_equalTo(SizeWidth(40));
    }];
    
    [self.priceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLab.mas_bottom);
        make.left.equalTo(self.backView).offset(SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTitleLab.mas_bottom);
        make.left.equalTo(self.backView).offset(SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(SizeWidth(20));
    }];
    
    [self.scheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SizeWidth(60));
        make.height.mas_equalTo(SizeWidth(20));
        make.top.equalTo(self.priceTitleLab.mas_bottom);
        make.left.equalTo(self.priceLab.mas_right).offset(SizeWidth(15));
    }];
}


- (void)updateBottomView:(JYBOrderListModel *)model{
    self.listModel = model;
    //订单状态 状态：0-待支付 10-派单中 20-已接单 30-进行中 40-已到港（待支付,支付额外费用） 50-已完成 60-已取消
    if (model.order_status.integerValue == 0) {
        self.desLab.hidden = YES;
        [self.commitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.commitBtn.backgroundColor = RGB(237, 171, 79);
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW - SizeWidth(30));
        }];
    }else if (model.order_status.integerValue == 10) {
        self.desLab.hidden = NO;
        [self.commitBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        self.commitBtn.backgroundColor = RGB(75, 157, 252);
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kScreenW - SizeWidth(30));
        }];
        
    }else if (model.order_status.integerValue == 40){
        self.desLab.hidden = YES;
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.other_price];
        [self.commitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        self.commitBtn.backgroundColor = RGB(237, 171, 79);
        [self.commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SizeWidth(100));
        }];
    }
}

- (void)commitBtnBtnAction{
    if (self.payBlock) {
        self.payBlock(!(self.listModel.order_status.integerValue == 0));
    }
}

- (void)scheBtnBtnAction{
    if (self.scheBlock) {
        self.scheBlock();
    }
}

#pragma mark -lazy
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel  *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _desLab.textColor = RGB(162, 162, 162);
        _desLab.text = @"装箱前一天17:30前支持取消订单";
        _desLab.textAlignment = NSTextAlignmentCenter;
    }
    return _desLab;
}

- (UILabel *)priceTitleLab{
    if (!_priceTitleLab) {
        _priceTitleLab = [[UILabel alloc] init];
        _priceTitleLab.font = [UIFont systemFontOfSize:SizeWidth(12)];
        _priceTitleLab.textColor = RGB(162, 162, 162);
        _priceTitleLab.text = @"需支付额外费用";
    }
    return _priceTitleLab;
}

- (UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = [UIFont systemFontOfSize:SizeWidth(12)];
        _priceLab.textColor = RGB(237, 171, 79);
        _priceLab.text = @"¥800";
    }
    return _priceLab;
}

- (UIButton *)scheBtn{
    if (!_scheBtn) {
        _scheBtn = [[UIButton alloc] init];
        [_scheBtn setTitle:@"价格明细" forState:UIControlStateNormal];
        [_scheBtn setTitleColor:RGB(237, 171, 79) forState:UIControlStateNormal];
        _scheBtn.titleLabel.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _scheBtn.layer.cornerRadius = 3;
        _scheBtn.layer.masksToBounds = YES;
        _scheBtn.layer.borderColor = RGB(237, 171, 79).CGColor;
        _scheBtn.layer.borderWidth = 1;
        [_scheBtn addTarget:self action:@selector(scheBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scheBtn;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        [_commitBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _commitBtn.layer.cornerRadius = 3;
        _commitBtn.layer.masksToBounds = YES;
        [_commitBtn addTarget:self action:@selector(commitBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}


@end
