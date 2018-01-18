//
//  AddInfoTableViewCell.m
//  Freight_Company
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddInfoTableViewCell.h"
#import <YYKit.h>

@implementation AddInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.text];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLab.text = title;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), 0, SizeWidth(110), SizeHeight(20))];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.centerY = self.contentView.centerY;
        _titleLab.text = @"tittle";
    }
    return _titleLab;
}

- (void)textchange {
    if (self.textBlock) {
        self.textBlock(nil, self.text.text);
    }
}

- (UITextField *)text {
    if (!_text) {
        _text = [[UITextField alloc] initWithFrame:FRAME(self.titleLab.right, 0, kScreenW - SizeWidth(130), SizeHeight(20))];
        _text.centerY = self.contentView.centerY;
        _text.font = [UIFont systemFontOfSize:14];
        [_text addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    }
    return _text;
}

@end
