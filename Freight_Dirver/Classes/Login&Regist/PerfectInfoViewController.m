//
//  PerfectInfoViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "PerfectInfoViewController.h"
#import "AddInfoTableViewCell.h"
#import "ReviewViewController.h"
#import <YYKit.h>
#import "AddPhotoCollectionViewCell.h"
#import "GTMBase64.h"

@interface PerfectInfoViewController ()<UITableViewDelegate,  UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>{
    int num;
}

@property (nonatomic, retain) UIButton *commitBtn;

@property (nonatomic, retain) NSArray *titleArr, *pleaceArr,*picArr;

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) UICollectionView *footCollcetion;

@property (nonatomic, retain) UIButton *btn1, *btn2, *btn3;

@property (nonatomic, retain) UISwitch *siwtch;

@property (nonatomic, retain) NSIndexPath *index;

@property (nonatomic,retain) NSMutableArray *addarr;

@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetFather];
    
    if (!self.model) {
        self.model = [[AddInfoModel alloc] init];
    }
    
    if (self.type == AddOne) {
        self.titleArr = @[@"所属运输公司",@"姓名",@"身份证号",@"紧急联络人",@"紧急联络人电话"];
        self.pleaceArr = @[@"所属运输公司",@"请填写本人姓名(必填)",@"请填写本人真实身份证号码",@"请填写紧急联络人姓名",@"请填写紧急联络人电话"];
    }else if (self.type == AddTwo){
        self.titleArr = @[@"车牌号", @"车型桥数", @"是否有白卡"];
        self.pleaceArr = @[@"请填写车牌号(必填)"];
    }else {
        [self.commitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    }
    [self.view addSubview:self.noUseTableView];
    [self.view addSubview:self.commitBtn];
    
}

- (void)resetFather {
    self.titleLab.text = @"完善信息";
    self.rightBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellId = [ NSString stringWithFormat:@"%lu", (long)indexPath.row];
    
    AddInfoTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.title = self.titleArr[indexPath.row];
    cell.textBlock = ^(NSIndexPath *index, NSString *text) {
        if (self.type == AddOne) {
            switch (indexPath.row) {
                case 0:
                    self.model.companyName = text;
                    break;
                case 1:
                    self.model.userName = text;
                    break;
                case 2:
                    self.model.userId = text;
                    break;
                case 3:
                    self.model.sosconnact = text;
                    break;
                case 4:
                    self.model.sosconnact = text;
                    break;
                    
                default:
                    break;
            }
        }else if (self.type == AddTwo) {
            self.model.carNum = text;
        }
    };
    if (self.type == AddOne) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.text.placeholder = self.pleaceArr[indexPath.row];
    }else if (self.type == AddTwo) {
        if (indexPath.row == 0) {
            cell.text.placeholder = self.pleaceArr[indexPath.row];
        }else if (indexPath.row == 1){
            cell.text.hidden = YES;
            self.btn1.centerY = cell.contentView.centerY;
            self.btn2.centerY = cell.contentView.centerY;
            self.btn3.centerY = cell.contentView.centerY;
            
            [cell.contentView addSubview:self.btn1];
            [cell.contentView addSubview:self.btn2];
            [cell.contentView addSubview:self.btn3];
        }else {
            cell.text.hidden = YES;
            self.siwtch.centerY = cell.contentView.centerY;
            [cell.contentView addSubview:self.siwtch];
        }
        
    }
    
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeight(55);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeight(50)) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = [UIColor whiteColor];
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(110))];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:FRAME((kScreenW - SizeWidth(685/2))/2,SizeHeight(30), SizeWidth(685)/2, SizeHeight(118/2))];
            image.backgroundColor = [UIColor clearColor];
            if (self.type == AddOne) {
                image.image = [UIImage imageNamed:@"1"];
            }else if (self.type == AddTwo){
                image.image = [UIImage imageNamed:@"2"];
            }else {
                image.image = [UIImage imageNamed:@"3"];
            }
            [view addSubview:image];
            
            view;
        });
        _noUseTableView.tableFooterView = ({
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            if (self.type == AddOne) {
                view.frame = FRAME(0, 0, kScreenW , SizeHeight(83));
                UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(10, SizeHeight(15), kScreenW/2, SizeHeight(20))];
                lab.font = [UIFont systemFontOfSize:13];
                lab.text = @"常跑路线:";
                UITextField *file = [[UITextField alloc] initWithFrame:FRAME(10, lab.bottom + SizeHeight(10), kScreenW - 20, SizeHeight(20))];
                file.font = [UIFont systemFontOfSize:13];
                [file addTarget:self action:@selector(textChage:) forControlEvents:UIControlEventEditingChanged];
                file.placeholder = @"请填写您的常跑路线，以便我们给您更好的派单";
    
                UILabel *line = [[UILabel alloc] initWithFrame:FRAME(15, 0, kScreenW, 1)];
                line.backgroundColor = RGB(239, 240, 241);
                
                [view addSubview:lab];
                [view addSubview:file];
                [view addSubview:line];
                
            }else if (self.type == AddTwo){
                view.frame = FRAME(0, 0, 0, 0 );
            }else {
                view.frame = FRAME(0, 0, kScreenW,  SizeHeight(400));
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.sectionInset = UIEdgeInsetsMake(0, SizeWidth(3), 0, SizeHeight(3));
                layout.itemSize = CGSizeMake(kScreenW/2 - SizeWidth(13), SizeHeight(105));
                layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                self.footCollcetion = [[UICollectionView alloc] initWithFrame:FRAME(SizeWidth(5), SizeHeight(35), kScreenW, SizeHeight(400)) collectionViewLayout:layout];
                self.footCollcetion.delegate = self;
                self.footCollcetion.dataSource = self;
                self.footCollcetion.backgroundColor = [UIColor clearColor];
                [view addSubview:self.footCollcetion];
            }
            
            view;
        });
    }
    return _noUseTableView;
}

- (void)textChage:(UITextField *)sender {
    self.model.alwaysLine = sender.text;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  尾视图  collection
    
    NSString *Id = [NSString stringWithFormat:@"%ld%ld1",(long)indexPath.section, (long)indexPath.row ];
    [self.footCollcetion registerClass:[AddPhotoCollectionViewCell class] forCellWithReuseIdentifier:Id];
    AddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Id forIndexPath:indexPath];
    NSString *str = [NSString stringWithFormat:@"%@", self.picArr[indexPath.row]];
    UIImage *image = [UIImage imageNamed:str];
    cell.imageStr = image;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.index =  indexPath;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takeAlbum];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //TODO
    }];
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:cancelAction];
    
    [self.navigationController presentViewController:actionSheet animated:YES completion:nil];
    
}


#pragma mark -- Photo
- (void)takeAlbum {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}


- (void)takePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alter show];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
      AddPhotoCollectionViewCell * cell = (AddPhotoCollectionViewCell *)[self.footCollcetion cellForItemAtIndexPath:self.index];
    [self.addarr replaceObjectAtIndex:self.index.row withObject:@"1"];
    
    cell.imageStr = editedImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)commitClick {
    PerfectInfoViewController *pre = [[PerfectInfoViewController alloc] init];
    pre.model = self.model;
    if (self.type == AddOne) {
        if (!self.model.companyName) {
            [ConfigModel mbProgressHUD:@"请输入所属公司" andView:nil];
            return;
        }
        
        if (!self.model.userName) {
            [ConfigModel mbProgressHUD:@"请输入姓名" andView:nil];
            return;
        }
        
        pre.type = AddTwo;
        [self.navigationController pushViewController:pre animated:YES];
    }else if (self.type == AddTwo){
        
        if (!self.model.carNum) {
            [ConfigModel mbProgressHUD:@"请输入车牌号" andView:nil];
            return;
        }
        
        pre.type = AddThree;
        [self.navigationController pushViewController:pre animated:YES];
    }else {
        
        for (int i = 0; i < self.addarr.count; i++) {
            NSString *str = self.addarr[i];
            if ([str intValue] == 0) {
                switch (i) {
                    case 0:
                        [ConfigModel mbProgressHUD:@"请上传身份证正面照" andView:nil];
                        break;
                    case 1:
                        [ConfigModel mbProgressHUD:@"请上传身份证反面照" andView:nil];
                        break;
                    case 2:
                        [ConfigModel mbProgressHUD:@"请上传行驶证正面照" andView:nil];
                        break;
                    case 3:
                        [ConfigModel mbProgressHUD:@"请上传行驶证正面照" andView:nil];
                        break;
                    case 4:
                        [ConfigModel mbProgressHUD:@"请上传白卡照" andView:nil];
                        break;
                        
                    default:
                        break;
                }
                return;
            }
            
        }
        NSString *arrimg ;
        for (int i = 0 ; i < 5; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
            AddPhotoCollectionViewCell * cell = (AddPhotoCollectionViewCell *)[self.footCollcetion cellForItemAtIndexPath:index];
            
            UIImage *image = cell.image.image;
            NSData *imgData = UIImageJPEGRepresentation(image,0.5);
            NSString *imgStr = [GTMBase64 stringByEncodingData:imgData];
            if (i == 0) {
                arrimg = imgStr;
            }else {
                NSString *str = [NSString stringWithFormat:@",%@", imgStr];
                arrimg = [arrimg stringByAppendingString:str];
            }
        }
        self.model.imageStr = arrimg;

        ReviewViewController *vc = [[ReviewViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] initWithFrame:FRAME(10, kScreenH - SizeHeight(45), kScreenW - 20, SizeHeight(40))];
        [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _commitBtn.backgroundColor = RGB(24, 141, 240);
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(130), 0, SizeWidth(50), SizeHeight(25))];
        [_btn1 setTitle:@"4桥" forState:UIControlStateNormal];
        _btn1.selected = YES;
        _btn1.tag = 100;
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"icon_xz"] forState:UIControlStateNormal];
        [_btn1 setImage:[UIImage imageNamed:@"icon_xz_pre"] forState:UIControlStateSelected];
    }
    return _btn1;
}
- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [[UIButton alloc] initWithFrame:FRAME(self.btn1.right + SizeWidth(5), 0, SizeWidth(50), SizeHeight(25))];
        [_btn2 setTitle:@"5桥" forState:UIControlStateNormal];
        _btn2.tag = 101;
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"icon_xz"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"icon_xz_pre"] forState:UIControlStateSelected];
    }
    return _btn2;
}

- (UIButton *)btn3 {
    if (!_btn3) {
        _btn3 = [[UIButton alloc] initWithFrame:FRAME(self.btn2.right + SizeWidth(5), 0, SizeWidth(50), SizeHeight(25))];
        [_btn3 setTitle:@"6桥" forState:UIControlStateNormal];
        _btn3.tag = 101;
        _btn3.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"icon_xz"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"icon_xz_pre"] forState:UIControlStateSelected];
    }
    return _btn3;
}

- (UISwitch *)siwtch {
    if (!_siwtch) {
        _siwtch = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenW - 60, 10, 20, 10)];
        [_siwtch setOn:YES];
        [_siwtch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _siwtch;
}

- (void)switchAction:(id)sender {
    
}

- (NSArray *)picArr {
    if (!_picArr) {
        _picArr = @[@"11", @"12", @"13", @"14", @"15"];
    }
    return _picArr;
}


- (void)click:(UIButton *)sender {
    if (!sender.selected) {
//        sender.selected = !sender.selected;
//        if (sender.tag == 100) {
//            self.womam.selected = NO;
//            isman = YES;
//        }else {
//            self.man.selected = NO;
//            isman = NO;
//        }
    }
    
}

- (NSMutableArray *)addarr {
    if (!_addarr) {
        NSArray *arr = @[@"0", @"0", @"0", @"0", @"0"];
        _addarr = [NSMutableArray arrayWithArray:arr];
    }
    return _addarr;
}



@end
