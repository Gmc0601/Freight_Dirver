//
//  JYBOrderOtherCostItmeCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/14.
//  Copyright © 2018年 cc. All rights reserved.
//  45

#import "JYBOrderOtherCostItmeCell.h"

@interface JYBOrderOtherCostItmeCell ()

@property (nonatomic ,strong)UILabel    *titleLab;

@property (nonatomic ,strong)UILabel    *desLab;

@property (nonatomic ,strong)UILabel    *valueLab;

@end

@implementation JYBOrderOtherCostItmeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)updateCellWithTitle:(NSString *)title des:(NSString *)des value:(NSString *)value{
    self.titleLab.text = title;
    self.desLab.text = [NSString stringIsNilOrEmpty:des]?@"":[NSString stringWithFormat:@"(%@)",des];
    self.valueLab.text = value;
}


- (void)p_initUI{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.desLab];
    [self.contentView addSubview:self.valueLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.titleLab.mas_right);
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
    }];
    
    [self.contentView addLineWithInset:UIEdgeInsetsMake(-1, SizeWidth(10), 0, -SizeWidth(10))];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = RGB(52, 52, 52);
        _titleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _titleLab.text = @"进港码头";
    }
    return _titleLab;
}

- (UILabel *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.textColor = RGB(162, 162, 162);
        _desLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _desLab.text = @"(北仑三期)";

    }
    return _desLab;
}

- (UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc] init];
        _valueLab.textColor = RGB(52, 52, 52);
        _valueLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _valueLab.textAlignment = NSTextAlignmentRight;
        _valueLab.text = @"¥500.00";
    }
    return _valueLab;
}


@end
