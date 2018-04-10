//
//  JYBAlertView.h
//  Freight_Company
//
//  Created by ToneWang on 2018/2/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

// LgCustomAlertW 宽
#define kLgCustomAlertW (kScreenW - SizeWidth(40))

@interface JYBAlertView : UIView

/**
 LGCustomAlertView 回调
 
 @param index --> 0：取消  1：确认  OtherItems 从2开始依次推
 */
typedef void(^CustomAlertResult)(NSInteger index);

/**
 自定义弹框
 
 @param title 标题
 @param message 内容
 @param cancelITem 取消按钮--白底黑字
 @param sureItem 确认按钮 -- 红底白字
 @param action 回调
 @return alertview对象
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelItem:(NSString *)cancelITem sureItem:(NSString *)sureItem clickAction:(CustomAlertResult)action;


/**
 显示
 */
-(void)show;



@end
