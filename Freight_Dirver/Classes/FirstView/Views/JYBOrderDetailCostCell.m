//
//  JYBOrderDetailCostCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  65

#import "JYBOrderDetailCostCell.h"

@interface JYBOrderDetailCostCell ()

@property (nonatomic ,strong)UILabel    *orderLab;

@property (nonatomic ,strong)UILabel    *timeLab;

@end

@implementation JYBOrderDetailCostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.orderLab];
    [self.contentView addSubview:self.timeLab];
    
    [self.orderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(10));
        make.left.equalTo(self.contentView).offset(SizeWidth(50));
        make.height.mas_equalTo(SizeWidth(20));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderLab.mas_bottom).offset(SizeWidth(5));
        make.left.equalTo(self.contentView).offset(SizeWidth(50));
        make.height.mas_equalTo(SizeWidth(20));
        make.right.equalTo(self.contentView).offset(-SizeWidth(15));
    }];
    
    
}

- (void)updataCellWithModel:(JYBOrderListModel *)model{
    
    self.orderLab.text = [NSString stringWithFormat:@"订单编号: %@",model.order_no];
    self.timeLab.text = [NSString stringWithFormat:@"下单时间: %@",model.create_time];

}

- (UILabel *)orderLab{
    if (!_orderLab) {
        _orderLab = [[UILabel alloc] init];
        _orderLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _orderLab.textColor = RGB(162, 162, 162);
        _orderLab.text = @"订单编号: 23224345";
    }
    return _orderLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _timeLab.textColor = RGB(162, 162, 162);
        _timeLab.text = @"下单时间: 2017-12-12 23:23:12";
    }
    return _timeLab;
}


@end
