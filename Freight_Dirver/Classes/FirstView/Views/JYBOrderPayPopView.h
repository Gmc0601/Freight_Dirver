//
//  JYBOrderPayPopView.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 JYBOrderPayPopView 回调
*/
typedef void(^JYBOrderPayPopViewResult)();


@interface JYBOrderPayPopView : UIView

/**
 自定义弹框
 @param action 回调
 @return alertview对象
 */
- (instancetype)initWithPayAmount:(CGFloat)payamount totalAmount:(CGFloat)totalAmount ClickAction:(JYBOrderPayPopViewResult)action;

/**
 显示
 */
-(void)show;


@end
