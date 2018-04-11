//
//  JYBOrderOtherCostImageCell.m
//  Freight_Company
//
//  Created by ToneWang on 2018/2/14.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "JYBOrderOtherCostImageCell.h"
#import "LXFullScreenImageBrowser.h"
#import <YYKit.h>

@interface JYBHomeOtherImageColectionCell : UICollectionViewCell

@property (nonatomic ,strong)UIImageView *iconImageView;
@end


@implementation JYBHomeOtherImageColectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end



@interface JYBOrderOtherCostImageCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LXImageLoopBrowserDelegate, LXFullScreenImageBrowserDelegate>

@property (nonatomic ,strong)UILabel    *titleLab;

@property (nonatomic ,strong)UICollectionView *myCollectionView;

@property (nonatomic ,strong)NSMutableArray     *dataArr;

@end

@implementation JYBOrderOtherCostImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self p_initUI];
    }
    return self;
}

- (void)p_initUI{
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.myCollectionView];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SizeWidth(10));
        make.left.equalTo(self.contentView).offset(SizeWidth(15));
        make.width.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(SizeWidth(40));
    }];
    
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-SizeWidth(10));
    }];
    
    
}


#pragma mark - LXImageLoopBrowserDelegate
- (void)imageLoopBrowser:(LXImageLoopBrowser *)imageLoopBrowser didOnceTapAtIndex:(NSUInteger)index {
    
    LXFullScreenImageBrowser * browser = (LXFullScreenImageBrowser *)imageLoopBrowser;
    if ([browser respondsToSelector:@selector(dismiss)]) {
        [browser dismiss];
    }
}

- (UIImage *)imageLoopBrowser:(LXImageLoopBrowser *)imageLoopBrowser placeholderImageForIndex:(NSInteger)index {
    return [self.imageView image];
}

- (CGRect)imageLoopBrowser:(LXFullScreenImageBrowser *)imageLoopBrowser startRectForIndex:(NSInteger)index {
    return self.imageView.frame;
}

- (UIView *)imageLoopBrowser:(LXFullScreenImageBrowser *)imageLoopBrowser originViewForIndex:(NSInteger)index {
    return self.imageView;
}


- (void)updateCellWithArr:(NSMutableArray *)arr{
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:arr];
    [self.myCollectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JYBHomeOtherImageColectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JYBHomeOtherImageColectionCell class]) forIndexPath:indexPath];
    NSString *imageStr = [self.dataArr objectAtIndex:indexPath.row];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:imageStr] placeholder:nil];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SizeWidth(50), SizeWidth(50));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, SizeWidth(10), 0, SizeWidth(10));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return SizeWidth(10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imageStr = [self.dataArr objectAtIndex:indexPath.row];
    
    LXFullScreenImageBrowser * browser = [[LXFullScreenImageBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    browser.delegate = self;
    browser.fullScreenDelegate = self;
    browser.imageUrls =@[imageStr];
    browser.currentIndex = 0;
    browser.zoomEnabled = YES;
    browser.imageContentMode = UIViewContentModeScaleAspectFit;
    [browser show];
}


- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置最小行间距
        flowLayout.minimumLineSpacing = 0;
        //最小列间距
        flowLayout.minimumInteritemSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_myCollectionView registerClass:[JYBHomeOtherImageColectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JYBHomeOtherImageColectionCell class])];
    }
    return _myCollectionView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:SizeWidth(15)];
        _titleLab.textColor = RGB(52, 52, 52);
        _titleLab.text = @"其他费用凭证";
    }
    return _titleLab;
}
@end
