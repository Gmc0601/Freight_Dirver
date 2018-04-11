//
//  CPHomeEvalAddImageView.m
//  Charging
//
//  Created by ToneWang on 2018/3/25.
//  Copyright © 2018年 dbmao. All rights reserved.
//

#import "CPHomeEvalAddImageView.h"
#import <YYKit.h>

#import "UIButton+LXMImagePosition.h"


@interface CPEvalImageButtonView : UIView

@property (nonatomic ,strong)UIButton *imageButton; //标签名字

@property (nonatomic ,strong)UIButton *deleteButton;

@property (nonatomic ,strong)UIImage *image;

@property (nonatomic ,strong)NSString *imageUrl;


@end

@implementation CPEvalImageButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    _imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,SizeWidth(80),SizeWidth(80))];
    [self addSubview:_imageButton];
    
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(60), 0, SizeWidth(20), SizeWidth(20))];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"qrjg_icon_sc"] forState:UIControlStateNormal];
    [self addSubview:_deleteButton];
    
}


@end

@interface CPHomeEvalAddImageView ()

@property (nonatomic ,strong)UIButton *addImageButton;

@property (nonatomic ,strong)UIScrollView *myScrollView;

@end

@implementation CPHomeEvalAddImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.myScrollView];
    
    [self.myScrollView addSubview:self.addImageButton];
}



- (void)addImageButtonWithImage:(UIImage *)image{
    
    [self.imageArray addObject:image];
    
    float x = (self.imageArray.count-1)*(SizeWidth(80)+SizeWidth(10)) +SizeWidth(15);
    CPEvalImageButtonView *imageBtnView = [[CPEvalImageButtonView alloc] initWithFrame:CGRectMake(x, 0, SizeWidth(80), SizeWidth(80))];
    [imageBtnView.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageBtnView.imageButton setImage:image forState:UIControlStateNormal];
    
    [self.myScrollView addSubview:imageBtnView];
    [self.imageButtonArray addObject:imageBtnView];
    
    if (self.imageArray.count>=9) {
        self.addImageButton.hidden = YES;
    }else{
        [self.addImageButton setFrame:CGRectMake((self.imageArray.count)*SizeWidth(90) +SizeWidth(15), 0, SizeWidth(80), SizeWidth(80))];
        self.myScrollView.contentSize = CGSizeMake(self.addImageButton.right+10, SizeWidth(90));
        
    }
    
}

- (void)addImageButtonWithImage:(UIImage *)image url:(NSString *)url{
    if (image == nil) {
        [self.imageArray addObject:url];
    }else{
        [self.imageArray addObject:image];
        
    }
    
    float x = (self.imageArray.count-1)*(SizeWidth(80)+SizeWidth(10)) +SizeWidth(15);
    CPEvalImageButtonView *imageBtnView = [[CPEvalImageButtonView alloc] initWithFrame:CGRectMake(x, 0, SizeWidth(80), SizeWidth(80))];
    [imageBtnView.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (image == nil) {
        [imageBtnView.imageButton setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"wctx_btn_zp_144 (2)"]];
        
    }else{
        [imageBtnView.imageButton setImage:image forState:UIControlStateNormal];
        
    }
    
    [self.myScrollView addSubview:imageBtnView];
    [self.imageButtonArray addObject:imageBtnView];
    
    if (self.imageArray.count>=9) {
        self.addImageButton.hidden = YES;
    }else{
        [self.addImageButton setFrame:CGRectMake((self.imageArray.count)*SizeWidth(90) +SizeWidth(15), 0, SizeWidth(80), SizeWidth(80))];
        self.myScrollView.contentSize = CGSizeMake(self.addImageButton.right+10, SizeWidth(90));
        
    }
    
}


- (UIScrollView *)myScrollView{
    if (_myScrollView == nil) {
        _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom, kScreenW, SizeWidth(90))];
    }
    return _myScrollView;
}


//点击删除按钮
- (void)deleteButtonClicked:(UIButton *)button{
    
    NSInteger currentIndex = [self.imageButtonArray indexOfObject:button.superview];
    [self.imageArray removeObjectAtIndex:currentIndex];
    [self.imageButtonArray removeObjectAtIndex:currentIndex];
    
    [button.superview removeFromSuperview];
    
    for (NSInteger i = 0; i < self.imageButtonArray.count; i++) {
        
        CPEvalImageButtonView *imageBtn = (CPEvalImageButtonView *)[self.imageButtonArray objectAtIndex:i];
        float x = i *SizeWidth(90) + SizeWidth(15);
        [imageBtn setFrame:CGRectMake(x, 0, SizeWidth(80),SizeWidth(80))];
    }
    //设置picker frame
    [self.addImageButton setFrame:CGRectMake(_imageButtonArray.count*SizeWidth(90)+SizeWidth(15), 0, SizeWidth(80), SizeWidth(80))];
    
    if (self.addImageButton.hidden) {
        self.addImageButton.hidden = NO;
    }
    self.myScrollView.contentSize = CGSizeMake(self.addImageButton.right + 10, SizeWidth(90));
    if (self.clickDeleteBlock) {
        self.clickDeleteBlock(currentIndex);
    }
}

//点击添加图片的按钮
- (void)imagePickerClicked{
    
    if (self.clickAddImageBlock) {
        self.clickAddImageBlock();
    }
}





#pragma mark -- 懒加载
- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)imageButtonArray{
    if (_imageButtonArray == nil) {
        _imageButtonArray = [[NSMutableArray alloc] init];
    }
    return _imageButtonArray;
}


- (UIButton *)addImageButton{
    if (_addImageButton == nil) {
        _addImageButton = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(15), 0, SizeWidth(80), SizeWidth(80))];
        [_addImageButton setImage:[UIImage imageNamed:@"wctx_btn_zp_144 (2)"] forState:UIControlStateNormal];
        [_addImageButton addTarget:self action:@selector(imagePickerClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageButton;
}


@end
