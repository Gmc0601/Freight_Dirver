//
//  ESPickerView.m
//  PEPatient
//
//  Created by 李新星 on 16/3/10.
//  Copyright © 2016年 EEGSmart. All rights reserved.
//

#import "ESPickerView.h"
#import "Masonry.h"

@interface ESPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView * bottomBgView;
@property (copy, nonatomic) ESPickerComplete completeBlock;

@property (strong, nonatomic) UIDatePicker * datePicker;
@property (strong, nonatomic) UIPickerView * itemPicker;
@property (strong, nonatomic) NSArray<NSString *> *items;

@end

@implementation ESPickerView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(250);
    }];
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, - 1.0 / kScreenW);
    bgView.layer.shadowOpacity = 0.5;
    
    UIView * barView = [[UIView alloc] init];
    barView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.height.mas_equalTo(39);
    }];
    //设置阴影
    //    barView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //    barView.layer.shadowOffset = CGSizeMake(0, 1.0 / kScreenScale);
    //    barView.layer.shadowOpacity = 0.5;
    barView.backgroundColor = [UIColor whiteColor];
    
    self.bottomBgView = bgView;
    
    UIButton * leftBtn = [[UIButton alloc] init];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitleColor:RGB(24, 141, 239) forState:UIControlStateNormal];
    [barView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barView);
        make.top.equalTo(barView);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(60);
    }];
    
    UIButton * rightBtn = [[UIButton alloc] init];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(comfirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:RGB(24, 141, 239) forState:UIControlStateNormal];
    [barView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(barView);
        make.top.equalTo(barView);
        make.height.mas_equalTo(39);
        make.width.mas_equalTo(60);
    }];
}

#pragma mark - Setter and getter
- (UIPickerView *)itemPicker {
    if (!_itemPicker) {
        _itemPicker = [[UIPickerView alloc] init];
        _itemPicker.backgroundColor = [UIColor whiteColor];
        _itemPicker.dataSource = self;
        _itemPicker.delegate = self;
    }
    return _itemPicker;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //这里有一个疑问。正常情况下locale会根据手机设置自动国际化，但是测试手机中文系统，datapick确是英文，所以在此设置一下
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _datePicker;
}

#pragma mark - Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.items.count;
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return self.items[row];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        //        tView.minimumFontSize = 14;
        //        tView.adjustsLetterSpacingToFitWidth = YES;
    }
    tView.text = self.items[row];
    return tView;
}

#pragma mark - Event response
- (void) cancelButtonClick {
    if (self.completeBlock) {
        self.completeBlock(self, nil, nil);
    }
}

- (void) comfirmButtonClick {
    if (self.completeBlock) {
        if (_datePicker.superview) {
            self.completeBlock(self, nil, _datePicker.date);
        }
        else {
            NSInteger row = [self.itemPicker selectedRowInComponent:0];
            self.completeBlock(self, self.items[row], nil);
        }
    }
}

#pragma mark - Public method
- (void) animationShowWithItems:(NSArray<NSString *> *)items selectedItemComplete:(ESPickerComplete)complete {
    self.completeBlock = complete;
    self.items = items;
    if (_datePicker) {
        [_datePicker removeFromSuperview];
    }
    [self.itemPicker reloadAllComponents];
    
    [self animationShowContentWithPicker:self.itemPicker];
}

- (void) animationShowWithDate:(NSDate *)date maximumDate:(NSDate *)maximumDate minimumDate:(NSDate *)minimumDate selectedItemComplete:(ESPickerComplete)complete {
    self.completeBlock = complete;
    if (_itemPicker) {
        [_itemPicker removeFromSuperview];
    }
    date = date ? date : [NSDate date];
    self.datePicker.date = date;
    if (maximumDate)  self.datePicker.maximumDate = maximumDate;
    if (minimumDate)  self.datePicker.minimumDate = minimumDate;

    [self animationShowContentWithPicker:self.datePicker];
}

- (void) animationShowContentWithPicker:(UIView *)picker {
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBgView);
        make.right.equalTo(self.bottomBgView);
        make.bottom.equalTo(self.bottomBgView);
        make.top.equalTo(self.bottomBgView).with.offset(40);
    }];

    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(200);
    }];
    [self layoutIfNeeded];
    
    self.hidden = NO;
    
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];

    
}

- (void) animationDismiss {
    [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(200);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
