//
//  JYBOrderDetailBoxInfoCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  55

#import "JYBOrderDetailBoxInfoCell.h"

@interface JYBOrderDetailBoxInfoCell ()

@property (nonatomic ,strong)UIButton   *iconBtn;

@property (nonatomic ,strong)UILabel    *titleLab;

@property (nonatomic ,strong)UILabel    *valueLab;

//@property (nonatomic ,strong)UIButton   *pinBtn;

@property (nonatomic ,strong)UIButton   *otherBtn;


@end

@implementation JYBOrderDetailBoxInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.iconBtn];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.valueLab];
//    [self.contentView addSubview:self.pinBtn];
    [self.contentView addSubview:self.otherBtn];
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(SizeWidth(50));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.iconBtn.mas_right);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SizeWidth(60));
        make.height.mas_equalTo(SizeWidth(20));
        make.right.equalTo(self.valueLab.mas_left).offset(-SizeWidth(10));
        make.centerY.equalTo(self.contentView);
    }];
    
//    [self.pinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
//        make.width.mas_equalTo(SizeWidth(30));
//    }];
    [self.contentView addLineWithInset:UIEdgeInsetsMake(-1, 0, 0, 0)];

}

- (void)updateCellWithIcon:(NSString *)icon title:(NSString *)title value:(NSString *)value other:(BOOL)other{
    
    [self.iconBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    self.titleLab.text = title;
    
    self.valueLab.text = value;
    
    self.otherBtn.hidden = !other;
    
}

- (void)otherBtnAction{
    if (self.otherBlock) {
        self.otherBlock();
    }
}

- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [[UIButton alloc] init];
        [_iconBtn setImage:[UIImage imageNamed:@"icon_dh"] forState:UIControlStateNormal];
    }
    return _iconBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:SizeWidth(16)];
        _titleLab.textColor = RGB(52, 52, 52);
        _titleLab.text = @"箱型";
    }
    return _titleLab;
}

- (UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc] init];
        _valueLab.font = [UIFont systemFontOfSize:SizeWidth(16)];
        _valueLab.textColor = RGB(52, 52, 52);
        _valueLab.textAlignment = NSTextAlignmentRight;
        _valueLab.text = @"小柜 1x20GP";
    }
    return _valueLab;
}

//- (UIButton *)pinBtn{
//    if (!_pinBtn) {
//        _pinBtn = [[UIButton alloc] init];
//        [_pinBtn setImage:[UIImage imageNamed:@"xd_icon_p"] forState:UIControlStateNormal];
//    }
//    return _pinBtn;
//}


- (UIButton *)otherBtn{
    if (!_otherBtn) {
        _otherBtn = [[UIButton alloc] init];
        [_otherBtn setTitle:@"查看明细" forState:UIControlStateNormal];
        [_otherBtn setTitleColor:RGB(237, 171, 79) forState:UIControlStateNormal];
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _otherBtn.layer.cornerRadius = 3;
        _otherBtn.layer.masksToBounds = YES;
        _otherBtn.layer.borderColor = RGB(237, 171, 79).CGColor;
        _otherBtn.layer.borderWidth = 1;
        _otherBtn.userInteractionEnabled = NO;
        [_otherBtn addTarget:self action:@selector(otherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherBtn;
}


@end
