//
//  AddPhotoCollectionViewCell.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AddPhotoCollectionViewCell.h"

@implementation AddPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.image = [[UIImageView alloc] initWithFrame:FRAME(0, 0, SizeWidth(163), SizeHeight(107))];
        self.image.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.image];
    }
    return self;
}

- (void)setImageStr:(UIImage *)imageStr {
    self.image.image = imageStr;
}

@end
