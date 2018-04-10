//
//  UIView+line.h
//  pregnancy
//
//  Created by huangjiming on 9/23/16.
//  Copyright © 2016 babytree. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (line)

/**
 *  功能:横向分割线，top为－1则以bottom为准，不为-1则以top为准
 */
- (UIView *)addLineWithInset:(UIEdgeInsets)aEdgeInsets;

/**
 *  功能:纵向分割线，left为－1则以right为准，不为-1则以left为准
 */
- (UIView *)addVLineWithInset:(UIEdgeInsets)aEdgeInsets;

/**
 指定位置添加分割线
 
 @param inset 上下左右间距 inset.bottom 没用，使用 inset.top 指定上间距
 @param mask UIViewAutoresizingFlexibleTopMargin or UIViewAutoresizingFlexibleBottomMargin
 @param color 颜色，nil 就使用默认色 0xe4e4e4
 */
- (UIView *)addHorizontalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(nullable UIColor *)color;

/**
 指定位置添加垂直分割线
 
 @param inset 上下左右间距 inset.riright 没用，使用 inset.left 指定左间距
 @param mask UIViewAutoresizingFlexibleLeftMargin or UIViewAutoresizingFlexibleRightMargin
 @param color 颜色，nil 就使用默认色 0xe4e4e4
 */
- (UIView *)addVerticalSpeparatorWithInset:(UIEdgeInsets)inset automaskVertical: (UIViewAutoresizing)mask color:(nullable UIColor *)color;


@end
