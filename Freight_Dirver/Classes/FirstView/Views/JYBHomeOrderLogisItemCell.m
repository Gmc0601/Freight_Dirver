//
//  JYBHomeOrderLogisItemCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBHomeOrderLogisItemCell.h"

@interface JYBHomeOrderLogisItemCell ()

@property (nonatomic ,strong)UILabel     *titleLabel;       ///<标题

@property (nonatomic ,strong)UILabel     *timeLabel;        ///<时间

@end

@implementation JYBHomeOrderLogisItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.dotBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(15));
        make.left.equalTo(self.contentView).offset(SizeWidth(50));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(SizeWidth(10));
        make.left.equalTo(self.contentView).offset(SizeWidth(50));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
        make.height.mas_greaterThanOrEqualTo(SizeWidth(15));
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(15));
    }];

    [self.dotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).offset(SizeWidth(3));
        make.left.equalTo(self.contentView).offset(SizeWidth(20));
        make.width.height.mas_equalTo(SizeWidth(10));
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.dotBtn.mas_top);
        make.centerX.equalTo(self.dotBtn);
        make.width.mas_equalTo(1);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dotBtn.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.dotBtn);
        make.width.mas_equalTo(1);
    }];
    
}


- (void)updateCellWithModel:(JYBOrderLogisticsModel *)model{
    
    self.timeLabel.text = model.create_time;
    self.titleLabel.text = model.logistics_title;
}


#pragma mark - lazy


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = RGB(162, 162, 162);
        _timeLabel.font = [UIFont systemFontOfSize:SizeWidth(13)];
        _timeLabel.text = @"2017-12-12 12:34:35";
    }
    return _timeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGB(52, 52, 52);
        _titleLabel.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"司机条巷教练卡就浪费空间啊老骥伏枥卡就拉开时间分开了按法";
    }
    return _titleLabel;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = RGB(228, 228, 228);
    }
    return _topLine;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = RGB(228, 228, 228);
    }
    return _bottomLine;
}

- (UIButton *)dotBtn{
    if (!_dotBtn) {
        _dotBtn = [[UIButton alloc] init];
        [_dotBtn setImage:[UIImage imageNamed:@"icon_xz"] forState:UIControlStateNormal];
    }
    return _dotBtn;
}

@end
