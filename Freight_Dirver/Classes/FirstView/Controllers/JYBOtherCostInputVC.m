//
//  JYBOtherCostInputVC.m
//  Freight_Dirver
//
//  Created by ToneWang on 2018/4/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOtherCostInputVC.h"
#import "UITextView+FastKit.h"
#import "CPHomeEvalAddImageView.h"
#import <YYKit.h>
#import "AppAlertViewController.h"

@interface JYBOtherCostInputVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic ,strong)UILabel        *costTitleLab;

@property (nonatomic ,strong)UITextField    *myTextFeild;

@property (nonatomic ,strong)UILabel        *inpuTitleLab;

@property (nonatomic ,strong)UITextView     *inputTextView;

@property (nonatomic ,strong)UILabel        *picTitleLab;

@property (nonatomic ,strong)CPHomeEvalAddImageView *addImageView;

@property (nonatomic ,strong)NSMutableArray *imageUrlArray;

@property (nonatomic ,strong)UIView           *bottomView;

@end

@implementation JYBOtherCostInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    [self.view addSubview:self.costTitleLab];
    [self.view addSubview:self.myTextFeild];
    [self.view addSubview:self.inpuTitleLab];
    [self.view addSubview:self.inputTextView];
    [self.view addSubview:self.picTitleLab];
    [self.view addSubview:self.addImageView];

    [self.view addSubview:self.bottomView];
    
    [self.view addLineWithInset:UIEdgeInsetsMake(64+SizeWidth(50), 0, 0, 0)];

}

- (void)resetFather {
    self.titleLab.text = @"额外费用明细";
    self.rightBar.hidden = YES;
    
}

- (void)takeAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        AppAlertViewController *alert = [[AppAlertViewController alloc] initWithParentController:self];
        [alert showAlert:@"提示" message:@"当前相机不可用" sureTitle:nil cancelTitle:@"确定" sure:nil cancel:nil];
    }
}



#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    [self.addImageView addImageButtonWithImage:editedImage];
    
    [self.imageUrlArray addObject:editedImage];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

- (void)commitBtnAction{
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:self.detailModel.order_id forKey:@"order_id"];
    [dic addUnEmptyString:self.detailModel.dock_id forKey:@"dock_id"];
    [dic addUnEmptyString:self.detailModel.weight_id forKey:@"weight_id"];
    [dic addUnEmptyString:self.detailModel.yard_id forKey:@"yard_id"];
    [dic addUnEmptyString:self.myTextFeild.text forKey:@"other_price"];
    [dic addUnEmptyString:self.myTextFeild.text forKey:@"other_price"];
    [dic addUnEmptyString:self.inputTextView.text forKey:@"other_price_desc"];

    [dic addUnEmptyString:self.inputTextView.text forKey:@"other_price_img"];

    NSMutableArray *base64Arr = [[NSMutableArray alloc] init];
    for (UIImage *image in self.imageUrlArray) {
        
        CGFloat scaleFloat;
        if (image.size.width>3000.0) {
            scaleFloat = 5;
        }else if (image.size.width>2000.0){
            scaleFloat = 4;
        }else if (image.size.width>1000.0){
            scaleFloat = 3;
        }else if (image.size.width>500.0){
            scaleFloat = 2;
        }else{
            scaleFloat = 1;
            
        }
        
        NSData *newData = [self imageWithImage:image scaledToSize:CGSizeMake(image.size.width/scaleFloat, image.size.height/scaleFloat)];
        NSString *base64Str = [newData base64EncodedString];
        [base64Arr addObject:base64Str];
    }
    
    NSString *imageArrJson = @"";
    for (NSString *title in base64Arr) {
        imageArrJson = [imageArrJson stringByAppendingString:title];
        imageArrJson = [imageArrJson stringByAppendingString:@","];
    }
    if (imageArrJson.length > 1) {
        imageArrJson = [imageArrJson substringToIndex:imageArrJson.length-1];
    }
    [dic addUnEmptyString:imageArrJson forKey:@"other_price_img"];

    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/Driver/Order/confirmInPort" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChangeNotification" object:nil];
            [weak.navigationController popToRootViewControllerAnimated:YES];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
    
}


- (UILabel  *)costTitleLab{
    if (!_costTitleLab){
        _costTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), 64, SizeWidth(100), SizeWidth(50))];
        _costTitleLab.text = @"其他费用总额";
        _costTitleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _costTitleLab.textColor = RGB(52, 52, 52);
    }
    return _costTitleLab;
}

- (UITextField  *)myTextFeild{
    if (!_myTextFeild){
        _myTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kScreenW - SizeWidth(150) - SizeWidth(10), 64, SizeWidth(150), SizeWidth(50))];
        _myTextFeild.placeholder = @"请输入金额";
        _myTextFeild.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _myTextFeild.textColor = RGB(52, 52, 52);
        _myTextFeild.textAlignment = NSTextAlignmentRight;
        _myTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _myTextFeild;
}


- (UILabel  *)inpuTitleLab{
    if (!_inpuTitleLab){
        _inpuTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeWidth(50) + 64, SizeWidth(100), SizeWidth(50))];
        _inpuTitleLab.text = @"其他费用说明";
        _inpuTitleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _inpuTitleLab.textColor = RGB(52, 52, 52);
    }
    return _inpuTitleLab;
}

- (UITextView  *)inputTextView{
    if (!_inputTextView){
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeWidth(100) + 64, kScreenW - SizeWidth(30), SizeWidth(150))];
        _inputTextView.backgroundColor = RGB(245, 245, 245);
        _inputTextView.layer.cornerRadius = 4;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.placeholder = @"请填写其他费用说明，例如超时费50元，过路费190元";
        _inputTextView.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _inputTextView.textColor = RGB(52, 52, 52);
    }
    return _inputTextView;
}


- (UILabel  *)picTitleLab{
    if (!_picTitleLab){
        _picTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeWidth(250) + 64, SizeWidth(100), SizeWidth(50))];
        _picTitleLab.text = @"其他费用凭证";
        _picTitleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _picTitleLab.textColor = RGB(52, 52, 52);
    }
    return _picTitleLab;
}

- (CPHomeEvalAddImageView *)addImageView{
    if (!_addImageView) {
        _addImageView =[[CPHomeEvalAddImageView alloc] initWithFrame:CGRectMake(0, self.picTitleLab.bottom + SizeWidth(10),kScreenW, SizeWidth(100))];
        
        __weak typeof(self)weakSelf = self;
        [_addImageView setClickAddImageBlock:^{
            __weak typeof(weakSelf)strongSelf = weakSelf;
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf takeAlbum];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf takePhoto];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //TODO
            }];
            [actionSheet addAction:action1];
            [actionSheet addAction:action2];
            [actionSheet addAction:cancelAction];
            
            [strongSelf.navigationController presentViewController:actionSheet animated:YES completion:nil];
            
        }];
        
        [_addImageView setClickDeleteBlock:^(NSInteger currentIndex){
            __weak typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf.imageUrlArray removeObjectAtIndex:currentIndex];
        }];
        
    }
    return _addImageView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.addImageView.bottom + SizeWidth(10) , kScreenW, SizeWidth(55))];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(SizeWidth(10), SizeWidth(5), kScreenW - SizeWidth(20), SizeWidth(45))];
        commitBtn.backgroundColor = RGB(24, 141, 240);
        [commitBtn setTitle:@"费用提交" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitBtn.layer.cornerRadius = 2;
        commitBtn.layer.masksToBounds = YES;
        [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:commitBtn];
    }
    return _bottomView;
}


@end
