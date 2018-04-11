//
//  JYBOrderDetailLogisUserCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  85

#import "JYBOrderDetailLogisUserCell.h"
#import <YYKit.h>

@interface JYBOrderDetailLogisUserCell ()

@property (nonatomic ,strong)UIImageView    *iconImageView;

@property (nonatomic ,strong)UILabel        *nameLab;

@property (nonatomic ,strong)UILabel        *numLab;

@property (nonatomic ,strong)UILabel        *pointLab;

@property (nonatomic ,strong)UIButton       *phontBtn;

@end

@implementation JYBOrderDetailLogisUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.numLab];
    [self.contentView addSubview:self.pointLab];
    [self.contentView addSubview:self.phontBtn];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.width.height.mas_equalTo(SizeWidth(50));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(15));
        make.left.equalTo(self.iconImageView.mas_right).offset(SizeWidth(10));
        make.width.mas_greaterThanOrEqualTo(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(20));
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(SizeWidth(15));
        make.left.equalTo(self.iconImageView.mas_right).offset(SizeWidth(10));
        make.width.mas_greaterThanOrEqualTo(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(20));
    }];
    
    [self.pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(20));
        make.left.equalTo(self.nameLab.mas_right).offset(SizeWidth(8));
        make.width.mas_greaterThanOrEqualTo(SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.phontBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.mas_equalTo(SizeWidth(60));
    }];
}

- (void)updateCellWithModel:(JYBOrderListModel *)model{

    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.driver_phone] placeholder:[UIImage imageNamed:@"jyb_order_driver"]];
    self.nameLab.text = [NSString stringWithFormat:@"司机：%@",model.driver_name];
    self.numLab.text = [self __getCarNoWithNo:model.car_no];

}

- (NSString *)__getCarNoWithNo:(NSString *)carno{
    
    if (carno.length > 3) {
        NSString *first = [carno substringToIndex:1];
        NSString *last = [carno substringFromIndex:3];
        return [NSString stringWithFormat:@"%@**%@",first,last];
        
    }else{
        return carno;
    }
    
}


- (void)phontBtnAction{
    if (self.logisPhoneBlock) {
        self.logisPhoneBlock();
    }
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"jyb_order_driver"];
        _iconImageView.layer.cornerRadius = SizeWidth(25);
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:SizeWidth(18)];
        _nameLab.textColor = RGB(52, 52, 52);
        _nameLab.text = @"张小乐";
    }
    return _nameLab;
}

- (UILabel *)numLab{
    if (!_numLab) {
        _numLab = [[UILabel alloc] init];
        _numLab.font = [UIFont systemFontOfSize:SizeWidth(17)];
        _numLab.textColor = RGB(52, 52, 52);
        _numLab.text = @"浙**14ED";
    }
    return _numLab;
}

- (UILabel *)pointLab{
    if (!_pointLab) {
        _pointLab = [[UILabel alloc] init];
        _pointLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _pointLab.textColor = RGB(253, 125, 39);
        _pointLab.text = @"5分";
    }
    return _pointLab;
}

- (UIButton *)phontBtn{
    if (!_phontBtn) {
        _phontBtn= [[UIButton alloc] init];
        [_phontBtn setImage:[UIImage imageNamed:@"ddxq_icon_dh"] forState:UIControlStateNormal];
        [_phontBtn addTarget:self action:@selector(phontBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phontBtn;
}

@end
