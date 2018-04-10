//
//  UIView+line.m
//  pregnancy
//
//  Created by huangjiming on 9/23/16.
//  Copyright © 2016 babytree. All rights reserved.
//

#import "UIView+line.h"
#import <YYKit.h>

@implementation UIView (line)

//inset.bottom unused
- (UIView *)addHorizontalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(UIColor *)color {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(inset.left, inset.top, self.width - inset.left - inset.right, 1.0 / [[UIScreen mainScreen] scale])];
    separator.autoresizingMask = mask | UIViewAutoresizingFlexibleWidth;
    
    separator.backgroundColor = color?:RGB(238, 238, 238);
    [self addSubview:separator];
    return separator;
}

//inset.right unused
- (UIView *)addVerticalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(UIColor *)color {
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(inset.left, inset.top, 1.0 / [[UIScreen mainScreen] scale], self.height - inset.top - inset.bottom)];
    separator.autoresizingMask = mask | UIViewAutoresizingFlexibleHeight;
    
    separator.backgroundColor = color?:RGB(238, 238, 238);
    [self addSubview:separator];
    return separator;
}

/**
 *  功能:横向分割线，top为－1则以bottom为准，不为-1则以top为准
 */
- (UIView *)addLineWithInset:(UIEdgeInsets)aEdgeInsets
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGB(238, 238, 238);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (aEdgeInsets.top != -1.f) {
            make.top.equalTo(@(aEdgeInsets.top));
        } else {
            make.bottom.equalTo(@(aEdgeInsets.bottom));
        }
        make.left.equalTo(@(aEdgeInsets.left));
        make.right.equalTo(@(aEdgeInsets.right));
        make.height.equalTo(@(1.f/[UIScreen mainScreen].scale));
    }];
    
    return lineView;
}

/**
 *  功能:纵向分割线，left为－1则以right为准，不为-1则以left为准
 */
- (UIView *)addVLineWithInset:(UIEdgeInsets)aEdgeInsets
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = RGB(238, 238, 238);
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(aEdgeInsets.top));
        if (aEdgeInsets.left != -1.f) {
            make.left.equalTo(@(aEdgeInsets.left));
        } else {
            make.right.equalTo(@(aEdgeInsets.right));
        }
        make.bottom.equalTo(@(aEdgeInsets.bottom));
        make.width.equalTo(@(1.f/[UIScreen mainScreen].scale));
    }];
    
    return lineView;
}

@end
