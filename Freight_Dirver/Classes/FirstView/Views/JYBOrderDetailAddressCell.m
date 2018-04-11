//
//  JYBOrderDetailAddressCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/13.
//  Copyright © 2018年 cc. All rights reserved.
//  110

#import "JYBOrderDetailAddressCell.h"

@interface JYBOrderDetailAddressCell ()

@property (nonatomic ,strong)UIView     *dotView;

@property (nonatomic ,strong)UILabel    *nameLab;

@property (nonatomic ,strong)UILabel    *addressTitleLab;

@property (nonatomic ,strong)UILabel    *addressLab;

@property (nonatomic ,strong)UILabel    *contactTitleLab;

@property (nonatomic ,strong)UILabel    *contactLab;

@property (nonatomic ,strong)UIButton   *phoneBtn;

@property (nonatomic ,strong)UIButton   *navBtn;

@property (nonatomic ,strong)UIButton   *messBtn;

@property (nonatomic ,strong)JYBOrderBoxAddressModel *addressModel;

@property (nonatomic ,assign)BOOL isbox;
@end

@implementation JYBOrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.dotView];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.addressTitleLab];
    [self.contentView addSubview:self.addressLab];
    [self.contentView addSubview:self.contactTitleLab];
    [self.contentView addSubview:self.contactLab];
    [self.contentView addSubview:self.phoneBtn];
    [self.contentView addSubview:self.messBtn];
    [self.contentView addSubview:self.navBtn];

    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(SizeWidth(8));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(SizeWidth(20));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(15));
        make.left.equalTo(self.dotView.mas_right).offset(SizeWidth(20));
        make.right.equalTo(self.contentView).offset(-SizeWidth(10));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.addressTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(SizeWidth(10));
        make.left.equalTo(self.dotView.mas_right).offset(SizeWidth(20));
        make.width.mas_equalTo(SizeWidth(65));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(SizeWidth(10));
        make.left.equalTo(self.addressTitleLab.mas_right).offset(SizeWidth(10));
        make.right.equalTo(self.contentView).offset(-SizeWidth(10));
        make.height.mas_lessThanOrEqualTo(SizeWidth(40));
    }];
    
    [self.contactTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLab.mas_top).offset(SizeWidth(40));
        make.left.equalTo(self.dotView.mas_right).offset(SizeWidth(20));
        make.width.mas_equalTo(SizeWidth(65));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.contactLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLab.mas_top).offset(SizeWidth(40));
        make.left.equalTo(self.contactTitleLab.mas_right).offset(SizeWidth(10));
        make.right.equalTo(self.contentView).offset(-SizeWidth(60));
        make.height.mas_equalTo(SizeWidth(15));
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-SizeWidth(5));
        make.width.height.mas_equalTo(SizeWidth(30));
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(10));
    }];
    
    [self.messBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneBtn.mas_left).offset(-SizeWidth(3));
        make.width.height.mas_equalTo(SizeWidth(30));
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(10));
    }];
    
    [self.navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.messBtn.mas_left).offset(-SizeWidth(3));
        make.width.height.mas_equalTo(SizeWidth(30));
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(10));
    }];
    
    [self.contentView addLineWithInset:UIEdgeInsetsMake(-1, 0, 0, 0)];
    
}

- (void)updateCellWithModel:(JYBOrderBoxAddressModel *)model isBox:(BOOL)isBox box_no:(NSString *)box_no{
    self.addressModel = model;
    self.isbox = isBox;
    if (isBox) {
        self.phoneBtn.hidden = YES;
        self.messBtn.hidden = YES;
        self.navBtn.hidden = YES;
        self.nameLab.text = [NSString stringWithFormat:@"提单号:%@",box_no];
        self.addressTitleLab.text = @"拿箱单地址";
        self.addressLab.text = model.box_address_desc;
        self.contactLab.text = [NSString stringWithFormat:@"%@  %@",model.box_linkman,model.box_linkman_phone];
        self.dotView.backgroundColor = RGB(75, 157, 252);
    }else{
        self.phoneBtn.hidden = NO;
        self.messBtn.hidden = NO;
        self.navBtn.hidden = NO;
        self.nameLab.text = [NSString stringWithFormat:@"%@-%@",model.city,model.address];
        self.addressTitleLab.text = @"装箱地址";
        self.addressLab.text = model.address_desc ;
        self.contactLab.text = [NSString stringWithFormat:@"%@  %@",model.boxman_name,model.boxman_phone];
        self.dotView.backgroundColor = RGB(237, 171, 79);
        

    }
}

- (void)phoneBtnActin{
    NSString *phone = self.isbox?self.addressModel.box_linkman_phone:self.addressModel.boxman_phone;
    if (self.phoneBlock) {
        self.phoneBlock(phone);
    }
}

- (void)messBtnActin{
    
}

- (void)navBtnBtnActin{
    if (self.navBlock){
        self.navBlock(self.addressModel);
    }
}

- (UIView *)dotView{
    if (!_dotView) {
        _dotView = [[UIView alloc] init];
        _dotView.layer.cornerRadius = SizeWidth(4);
        _dotView.layer.masksToBounds = YES;
        _dotView.backgroundColor = RGB(23, 141, 237);
    }
    return _dotView;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _nameLab.textColor = RGB(52, 52, 52);
        _nameLab.text = @"接单号:SSD423424";
    }
    return _nameLab;
}

- (UILabel *)addressTitleLab{
    if (!_addressTitleLab) {
        _addressTitleLab = [[UILabel alloc] init];
        _addressTitleLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _addressTitleLab.textColor = RGB(162, 162, 162);
        _addressTitleLab.text = @"拿箱单地址";
    }
    return _addressTitleLab;
}

- (UILabel *)addressLab{
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _addressLab.textColor = RGB(162, 162, 162);
        _addressLab.numberOfLines = 0;
        _addressLab.userInteractionEnabled = YES;
        _addressLab.text = @"宁波北仓三期西门3栋5楼503宁波北仓三期西门哇3424擦";
    }
    return _addressLab;
}


- (UILabel *)contactTitleLab{
    if (!_contactTitleLab) {
        _contactTitleLab = [[UILabel alloc] init];
        _contactTitleLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _contactTitleLab.textColor = RGB(162, 162, 162);
        _contactTitleLab.text = @"联系人";
    }
    return _contactTitleLab;
}


- (UILabel *)contactLab{
    if (!_contactLab) {
        _contactLab = [[UILabel alloc] init];
        _contactLab.font = [UIFont systemFontOfSize:SizeWidth(14)];
        _contactLab.textColor = RGB(162, 162, 162);
        _contactLab.text = @"张下菲";
        _contactLab.userInteractionEnabled = YES;
    }
    return _contactLab;
}


- (UIButton *)phoneBtn{
    if (!_phoneBtn) {
        _phoneBtn = [[UIButton alloc] init];
        [_phoneBtn setImage:[UIImage imageNamed:@"sj_icon_dh"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(phoneBtnActin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}



- (UIButton *)messBtn{
    if (!_messBtn) {
        _messBtn = [[UIButton alloc] init];
        [_messBtn setImage:[UIImage imageNamed:@"sj_icon_xx"] forState:UIControlStateNormal];
        [_messBtn addTarget:self action:@selector(messBtnActin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messBtn;
}

- (UIButton *)navBtn{
    if (!_navBtn) {
        _navBtn = [[UIButton alloc] init];
        [_navBtn setImage:[UIImage imageNamed:@"sj_icon_dw"] forState:UIControlStateNormal];
        [_navBtn addTarget:self action:@selector(navBtnBtnActin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBtn;
}







@end
