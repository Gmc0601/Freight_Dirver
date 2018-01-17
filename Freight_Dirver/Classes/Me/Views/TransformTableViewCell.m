//
//  TransformTableViewCell.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "TransformTableViewCell.h"
#import <YYKit.h>

@implementation TransformTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.detailLab];
        [self.contentView addSubview:self.moneyLab];
        [self.contentView addSubview:self.timelab];
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(16), SizeHeight(15), kScreenW/2 - SizeWidth(16), SizeHeight(15))];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.text = @"额外费用";
    }
    return _titleLab;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame: FRAME(SizeWidth(16), self.titleLab.bottom + SizeHeight(10), kScreenW/2 - SizeWidth(16), SizeHeight(15))];
        _detailLab.font = [UIFont systemFontOfSize:12];
        _detailLab.textColor = UIColorFromHex(0x999999);
        _detailLab.text = @"提箱号：TJ110110110";
    }
    return _detailLab;
}
- (UILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(15), kScreenW/2 - SizeWidth(16), SizeHeight(15))];
        _moneyLab.font = [UIFont systemFontOfSize:15];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.text = @"- ￥ 900.00";
    }
    return _moneyLab;
}

- (UILabel *)timelab {
    if (!_timelab) {
        _timelab = [[UILabel alloc] initWithFrame: FRAME(kScreenW/2, self.moneyLab.bottom + SizeHeight(10), kScreenW/2 - SizeWidth(16), SizeHeight(15))];
        _timelab.font = [UIFont systemFontOfSize:12];
        _timelab.textAlignment = NSTextAlignmentRight;
        _timelab.textColor = UIColorFromHex(0x999999);
        _timelab.text = @"2017-11-14 16：23：11";
    }
    return _timelab;
}


@end
