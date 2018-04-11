//
//  CPHomeEvalAddImageView.h
//  Charging
//
//  Created by ToneWang on 2018/3/25.
//  Copyright © 2018年 dbmao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickAddImageButtonBlock)();

typedef void(^clickDeleteImageButtonBlcok)(NSInteger currentIndex);

@interface CPHomeEvalAddImageView : UIView

@property (nonatomic ,strong)UILabel *titleLabel;

@property (nonatomic ,copy) clickAddImageButtonBlock clickAddImageBlock;

@property (nonatomic ,copy) clickDeleteImageButtonBlcok clickDeleteBlock;


@property (nonatomic ,strong) NSMutableArray *imageArray;

@property (nonatomic ,strong) NSMutableArray *imageButtonArray;


- (void)addImageButtonWithImage:(UIImage *)image;

- (void)addImageButtonWithImage:(UIImage *)image url:(NSString *)url;

@end
