//
//  HeadInfoView.h
//  Freight_Dirver
//
//  Created by cc on 2018/1/17.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadInfoView : UIView

@property (nonatomic, retain) UILabel *titleLab1, *titleLab2, *infoLab1, *infolab2;

- (instancetype)initWithFrame:(CGRect)frame title1:(NSString *)title1 title2:(NSString *)title2 color:(UIColor *)color;

@end
