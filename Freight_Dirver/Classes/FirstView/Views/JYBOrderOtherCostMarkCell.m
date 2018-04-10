//
//  JYBOrderOtherCostMarkCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/14.
//  Copyright © 2018年 cc. All rights reserved.
//  auto

#import "JYBOrderOtherCostMarkCell.h"

@interface JYBOrderOtherCostMarkCell ()

@property (nonatomic ,strong)UILabel    *titleLab;

@property (nonatomic ,strong)UILabel    *desLab;

@end

@implementation JYBOrderOtherCostMarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.desLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(20));
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom).offset(SizeWidth(5));
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.height.mas_greaterThanOrEqualTo(10);
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(10));
    }];
    
}

- (void)updateCellWithMark:(NSString *)mark{
    self.desLab.text = [NSString stringIsNilOrEmpty:mark]?@"无":mark;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = RGB(52, 52, 52);
        _titleLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _titleLab.text = @"其他费用说明:";
    }
    return _titleLab;
}

- (UILabel *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.textColor = RGB(162, 162, 162);
        _desLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _desLab.numberOfLines = 0;
        _desLab.text = @"等待费100，高速过路费100，什么费什么费，，有司机端填写";
    }
    return _desLab;
}


@end
