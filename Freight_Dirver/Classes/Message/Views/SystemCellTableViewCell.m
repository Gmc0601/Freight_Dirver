//
//  SystemCellTableViewCell.m
//  Freight_Company
//
//  Created by cc on 2018/1/19.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "SystemCellTableViewCell.h"
#import <YYKit.h>
#import "UILabel+StringFrame.h"

@implementation SystemCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.whiteView];
        [self.whiteView addSubview:self.contentLab];
    }
    return self;
}

- (void)update:(SystemModel *)model {
    
    self.contentLab.text = model.content;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeight(8.5), kScreenW - SizeWidth(60), SizeHeight(20))];
        _contentLab.textColor = UIColorHex(0x333333);
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 2;
        //        CGSize size = [_contentLab boundingRectWithSize:_contentLab.size];
        //        if (size.height > SizeHeight(40)) {
        //            size.height = SizeHeight(40);
        //        }_contentLab.size = size;
    }
    return _contentLab;
}

- (UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:FRAME(SizeWidth(25), 0, kScreenW - SizeWidth(50), SizeHeight(114))];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = 2;
        
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeight(65), kScreenW - SizeWidth(80), 1)];
        line.backgroundColor = UIColorFromHex(0xE0E0E0);
        [_whiteView addSubview:line];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), line.bottom + SizeHeight(17.5), kScreenW/2, SizeHeight(15))];
        lab.textColor = UIColorHex(0x999999);
        lab.font= [UIFont systemFontOfSize:13];
        lab.text = @"查看详情";
        [_whiteView addSubview:lab];
        
        UIImageView *logo = [[UIImageView alloc] initWithFrame:FRAME(kScreenW - SizeWidth(50) - SizeWidth(25), line.bottom + SizeHeight(17.5), SizeWidth(10), SizeHeight(16))];
        logo.backgroundColor = [UIColor clearColor];
        logo.image = [UIImage imageNamed:@"wd_icon_gd 拷贝"];
        [_whiteView addSubview:logo];
        
    }
    return _whiteView;
}



@end

