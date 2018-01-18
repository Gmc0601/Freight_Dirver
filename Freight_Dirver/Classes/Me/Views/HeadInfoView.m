//
//  HeadInfoView.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "HeadInfoView.h"

@implementation HeadInfoView

- (instancetype)initWithFrame:(CGRect)frame title1:(NSString *)title1 title2:(NSString *)title2 color:(UIColor *)color{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = color;
        [self addSubview:self.titleLab1];
        [self addSubview:self.titleLab2];
        [self addSubview:self.infoLab1];
        [self addSubview:self.infolab2];
        
        self.titleLab1.text = title1;
        self.titleLab2.text = title2;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
        image.backgroundColor = [UIColor clearColor];
        image.image = [UIImage imageNamed:@""];
        [self addSubview:image];
    }
    return self;
}

- (UILabel *)titleLab1 {
    if (!_titleLab1) {
        _titleLab1 = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeight(12.5), kScreenW/2, SizeHeight(12))];
        _titleLab1.backgroundColor = [UIColor clearColor];
        _titleLab1.textAlignment = NSTextAlignmentCenter;
        _titleLab1.textColor = RGBColorAlpha(255, 255, 255, 0.5);
        _titleLab1.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab1;
}
- (UILabel *)titleLab2 {
    if (!_titleLab2) {
        _titleLab2 = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(12.5), kScreenW/2, SizeHeight(12))];
        _titleLab2.backgroundColor = [UIColor clearColor];
        _titleLab2.textAlignment = NSTextAlignmentCenter;
        _titleLab2.textColor = RGBColorAlpha(255, 255, 255, 0.5);
        _titleLab2.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab2;
}
- (UILabel *)infoLab1 {
    if (!_infoLab1) {
        _infoLab1 = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeight(33), kScreenW/2, SizeHeight(12))];
        _infoLab1.backgroundColor = [UIColor clearColor];
        _infoLab1.textAlignment = NSTextAlignmentCenter;
        _infoLab1.textColor = [UIColor whiteColor];
        _infoLab1.font = [UIFont systemFontOfSize:13];
    }
    return _infoLab1;
}
- (UILabel *)infolab2 {
    if (!_infolab2) {
        _infolab2 = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, SizeHeight(33), kScreenW/2, SizeHeight(12))];
        _infolab2.backgroundColor = [UIColor clearColor];
        _infolab2.textAlignment = NSTextAlignmentCenter;
        _infolab2.textColor = [UIColor whiteColor];
        _infolab2.font = [UIFont systemFontOfSize:13];
    }
    return _infolab2;
}



@end
