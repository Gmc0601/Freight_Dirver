//
//  ESPickerView.h
//  PEPatient
//
//  Created by 李新星 on 16/3/10.
//  Copyright © 2016年 EEGSmart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ESPickerView;

typedef void(^ESPickerComplete)(ESPickerView * pickerView, NSString * item, NSDate * date);

@interface ESPickerView : UIControl

- (void) animationShowWithItems:(NSArray<NSString *> *)items selectedItemComplete:(ESPickerComplete)complete;
- (void) animationShowWithDate:(NSDate *)date maximumDate:(NSDate *)maximumDate minimumDate:(NSDate *)minimumDate selectedItemComplete:(ESPickerComplete)complete;

- (void) animationDismiss;

@end
