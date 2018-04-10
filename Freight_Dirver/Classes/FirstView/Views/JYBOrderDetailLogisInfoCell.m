//
//  JYBOrderDetailLogisInfoCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  90

#import "JYBOrderDetailLogisInfoCell.h"
#import "JYBOrderLogisticsModel.h"

@interface JYBOrderDetailLogisInfoCell ()

@property (nonatomic ,strong)UILabel    *logTitleLab;

@property (nonatomic ,strong)UILabel     *logInfoLab;

@property (nonatomic ,strong)UILabel    *logTimeLab;

@property (nonatomic ,strong)UIButton   *arrowBtn;
@end

@implementation JYBOrderDetailLogisInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    
    [self.contentView addSubview:self.logTitleLab];
    [self.contentView addSubview:self.logInfoLab];
    [self.contentView addSubview:self.logTimeLab];
    [self.contentView addSubview:self.arrowBtn];
    
    [self.logTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.top.equalTo(self.contentView).offset(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(15));
        make.right.equalTo(self.contentView).offset(-SizeWidth(50));
    }];
    
    [self.logInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.top.equalTo(self.logTitleLab.mas_bottom).offset(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(20));
        make.right.equalTo(self.contentView).offset(-SizeWidth(50));
    }];
    
    [self.logTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.top.equalTo(self.logInfoLab.mas_bottom).offset(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(15));
        make.right.equalTo(self.contentView).offset(-SizeWidth(50));
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(SizeWidth(45));
    }];
    
}

- (void)updateCellWithModel:(JYBOrderListModel *)model{
    if (model.logistics.count) {
        JYBOrderLogisticsModel *firLog = [model.logistics firstObject];
        self.logInfoLab.text = firLog.logistics_title;
        self.logTimeLab.text = firLog.create_time;
    }
}

- (UILabel *)logTitleLab{
    if (!_logTitleLab) {
        _logTitleLab = [[UILabel alloc] init];
        _logTitleLab.textColor = RGB(102, 102, 102);
        _logTitleLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _logTitleLab.text = @"最新物流信息";
    }
    return _logTitleLab;
}

- (UILabel *)logInfoLab{
    if (!_logInfoLab) {
        _logInfoLab = [[UILabel alloc] init];
        _logInfoLab.textColor = RGB(52, 52, 52);
        _logInfoLab.font = [UIFont systemFontOfSize:SizeWidth(16)];
    }
    return _logInfoLab;
}

- (UILabel *)logTimeLab{
    if (!_logTimeLab) {
        _logTimeLab = [[UILabel alloc] init];
        _logTimeLab.textColor = RGB(162, 162, 162);
        _logTimeLab.font = [UIFont systemFontOfSize:SizeWidth(13)];
    }
    return _logTimeLab;
}

- (UIButton *)arrowBtn{
    if (!_arrowBtn) {
        _arrowBtn = [[UIButton alloc] init];
        [_arrowBtn setImage:[UIImage imageNamed:@"icon_gd"] forState:UIControlStateNormal];
    }
    return _arrowBtn;
}

@end
