//
//  JYBOrderDetailMarkInfoCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  auto

#import "JYBOrderDetailMarkInfoCell.h"

@interface JYBOrderDetailMarkInfoCell ()

@property (nonatomic ,strong)UIButton   *iconBtn;

@property (nonatomic ,strong)UILabel    *titleLab;

@property (nonatomic ,strong)UILabel    *valueLab;

@end


@implementation JYBOrderDetailMarkInfoCell

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
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.mas_equalTo(SizeWidth(50));
        make.height.mas_equalTo(SizeWidth(55));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.iconBtn.mas_right);
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(SizeWidth(55));
    }];
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(-SizeWidth(5));
        make.left.equalTo(self.iconBtn.mas_right);
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.height.mas_greaterThanOrEqualTo(10);
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(15));
    }];
    
}

- (void)updateCellWithMark:(NSString *)mark{
    
    self.valueLab.text = mark;
}

- (UIButton *)iconBtn{
    if (!_iconBtn) {
        _iconBtn = [[UIButton alloc] init];
        [_iconBtn setImage:[UIImage imageNamed:@"ddxq_icon_ddbz"] forState:UIControlStateNormal];
    }
    return _iconBtn;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:SizeWidth(16)];
        _titleLab.textColor = RGB(52, 52, 52);
        _titleLab.text = @"订单备注";
    }
    return _titleLab;
}

- (UILabel *)valueLab{
    if (!_valueLab) {
        _valueLab = [[UILabel alloc] init];
        _valueLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _valueLab.textColor = RGB(162, 162, 162);
        _valueLab.numberOfLines = 0;
        _valueLab.text = @"深刻理解法律框架上历史课就放开了手为哦节日快乐副教授酸辣粉健康";
    }
    return _valueLab;
}


@end
