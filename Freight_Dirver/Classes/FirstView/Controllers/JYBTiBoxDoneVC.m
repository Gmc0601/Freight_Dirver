//
//  JYBTiBoxDoneVC.m
//  Freight_Dirver
//
//  Created by ToneWang on 2018/4/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBTiBoxDoneVC.h"
#import "CPHomeEvalAddImageView.h"
#import <YYKit.h>
#import "AppAlertViewController.h"
#import "UIView+line.h"

@interface JYBTiBoxDoneVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic ,strong)UILabel        *boxTitleLab;

@property (nonatomic ,strong)UITextField    *boxTextFeild;

@property (nonatomic ,strong)UILabel        *fengTitleLab;

@property (nonatomic ,strong)UITextField     *fengTextFeild;

@property (nonatomic ,strong)UILabel        *picTitleLab;

@property (nonatomic ,strong)CPHomeEvalAddImageView *addImageView;

@property (nonatomic ,strong)NSMutableArray *imageUrlArray;

@property (nonatomic ,strong)UIView           *bottomView;

@end

@implementation JYBTiBoxDoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    [self.view addSubview:self.boxTitleLab];
    [self.view addSubview:self.boxTextFeild];
    [self.view addSubview:self.fengTitleLab];
    [self.view addSubview:self.fengTextFeild];
    [self.view addSubview:self.picTitleLab];
    [self.view addSubview:self.addImageView];
    
    [self.view addSubview:self.bottomView];
     
     [self.view addLineWithInset:UIEdgeInsetsMake(64+SizeWidth(50), 0, 0, 0)];
    [self.view addLineWithInset:UIEdgeInsetsMake(64+SizeWidth(100), 0, 0, 0)];

    
}

- (void)resetFather {
    self.titleLab.text = @"完成提箱";
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
    
    if ([NSString stringIsNilOrEmpty:self.boxTextFeild.text]){
        [ConfigModel mbProgressHUD:@"请填写箱号" andView:nil];
        return;
    }
    if ([NSString stringIsNilOrEmpty:self.fengTextFeild.text]){
        [ConfigModel mbProgressHUD:@"请填写封号" andView:nil];
        return;
    }
    
    if (!self.imageUrlArray.count) {
        [ConfigModel mbProgressHUD:@"请选择提箱照片" andView:nil];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic addUnEmptyString:self.detailModel.driver_id forKey:@"driver_id"];
    [dic addUnEmptyString:self.detailModel.order_id forKey:@"order_id"];
    [dic addUnEmptyString:self.boxTextFeild.text forKey:@"box_no"];
    [dic addUnEmptyString:self.fengTextFeild.text forKey:@"close_no"];
    
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
    [dic addUnEmptyString:imageArrJson forKey:@"box_img_json_list"];
    
    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/Driver/Order/completeBox" params:dic resultBlock:^(id responseObject, NSError *error) {
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


- (UILabel  *)boxTitleLab{
    if (!_boxTitleLab){
        _boxTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), 64, SizeWidth(100), SizeWidth(50))];
        _boxTitleLab.text = @"箱号";
        _boxTitleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _boxTitleLab.textColor = RGB(52, 52, 52);
    }
    return _boxTitleLab;
}

- (UITextField  *)boxTextFeild{
    if (!_boxTextFeild){
        _boxTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kScreenW - SizeWidth(150) - SizeWidth(10), 64, SizeWidth(150), SizeWidth(50))];
        _boxTextFeild.placeholder = @"请填写箱号";
        _boxTextFeild.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _boxTextFeild.textColor = RGB(52, 52, 52);
        _boxTextFeild.textAlignment = NSTextAlignmentRight;
        _boxTextFeild.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _boxTextFeild;
}




- (UILabel  *)fengTitleLab{
    if (!_fengTitleLab){
        _fengTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), 64 + SizeWidth(50), SizeWidth(100), SizeWidth(50))];
        _fengTitleLab.text = @"封号";
        _fengTitleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _fengTitleLab.textColor = RGB(52, 52, 52);
    }
    return _fengTitleLab;
}

- (UITextField  *)fengTextFeild{
    if (!_fengTextFeild){
        _fengTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(kScreenW - SizeWidth(150) - SizeWidth(10), 64 + SizeWidth(50), SizeWidth(150), SizeWidth(50))];
        _fengTextFeild.placeholder = @"请填写封号(选填)";
        _fengTextFeild.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _fengTextFeild.textColor = RGB(52, 52, 52);
        _fengTextFeild.textAlignment = NSTextAlignmentRight;
        _fengTextFeild.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _fengTextFeild;
}




- (UILabel  *)picTitleLab{
    if (!_picTitleLab){
        _picTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeWidth(100) + 64, SizeWidth(100), SizeWidth(50))];
        _picTitleLab.text = @"提箱照片";
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
        [commitBtn setTitle:@"完成" forState:UIControlStateNormal];
        [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitBtn.layer.cornerRadius = 2;
        commitBtn.layer.masksToBounds = YES;
        [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:commitBtn];
    }
    return _bottomView;
}


- (NSMutableArray *)imageUrlArray{
    if (!_imageUrlArray) {
        _imageUrlArray = [[NSMutableArray alloc] init];
    }
    return _imageUrlArray;
}

@end
