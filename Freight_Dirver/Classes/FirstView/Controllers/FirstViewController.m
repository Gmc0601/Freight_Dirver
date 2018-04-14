//
//  FirstViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "FirstViewController.h"

#import "UserInfoViewController.h"
#import "HMSegmentedControl.h"
#import "JYBOrderSingleVC.h"
#import "JYBAlertView.h"
#import "JYBOrderCountModel.h"
#import <YYKit.h>

@interface FirstViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic ,strong)HMSegmentedControl *headTabView;

@property (nonatomic ,strong)UIPageViewController *pageViewController;

@property (nonatomic ,strong)NSArray  *vcArr;

@property (nonatomic ,strong)JYBOrderCountModel  *countModel;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self navigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"orderChangeNotification" object:nil];

    
    self.view.backgroundColor = [UIColor whiteColor];

    [self __getCurrentModudleData];
}


- (void)__getCurrentModudleData{
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录
            [self getCountData];

        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
            [self __getTakeerCountData];

        }
    }else {
        //   未登录
    }
    
}

- (void)__getTakeerCountData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/DBoxman/Order/orderCountList" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            weak.countModel = [JYBOrderCountModel modelWithDictionary:datadic[@"data"]];
            
            [weak __setUI];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
            [weak __setUI];
        }
    }];
}


- (void)getCountData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [ConfigModel showHud:self];
    NSLog(@"%@", dic);
    WeakSelf(weak)
    [HttpRequest postPath:@"/Driver/Order/orderCountList" params:dic resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:weak];
        
        NSLog(@"%@", responseObject);
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            weak.countModel = [JYBOrderCountModel modelWithDictionary:datadic[@"data"]];
            
            [weak __setUI];
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
            [weak __setUI];
        }
    }];
    
}

- (void)__setUI{
    
    
    [self.view addSubview:self.headTabView];
    [self.headTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(SizeWidth(45));
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.headTabView.mas_bottom);
    }];
    [self.pageViewController didMoveToParentViewController:self];
    [self.pageViewController setViewControllers:@[[self.vcArr objectAtIndex:0]]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO completion:nil];
    WeakObj(self);
    self.headTabView.indexChangeBlock = ^(NSInteger index){
        
        [selfWeak.pageViewController setViewControllers:@[[selfWeak.vcArr objectAtIndex:index]]
                                              direction:UIPageViewControllerNavigationDirectionReverse
                                               animated:NO completion:nil];
    };
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshData{
    if (self.headTabView.selectedSegmentIndex == 0){
        [self.headTabView setSelectedSegmentIndex:1 animated:NO];
        [self.pageViewController setViewControllers:@[[self.vcArr objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionReverse
                                               animated:NO completion:nil];
    }else if (self.headTabView.selectedSegmentIndex == 1){
        [self.headTabView setSelectedSegmentIndex:2 animated:NO];
        [self.pageViewController setViewControllers:@[[self.vcArr objectAtIndex:2]] direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO completion:nil];
    }else{
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ConfigModel getBoolObjectforKey:IsLogin]) {
        if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
            //   司机登录
        }
        if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
            //  装箱工登录
        }
    }else {
        //   未登录 
    }
    
    
}

- (void)navigation {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"nav_icon_kf"] action:@selector(backAction)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:view.frame];
    img.image = [UIImage imageNamed:@"icon_jyb"];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:img];
    self.navigationItem.titleView = view;
}
//  客服
-(void)backAction {
    [self.navigationController pushViewController:[UserInfoViewController new] animated:YES];
}



#pragma mark -
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    NSInteger index =  [self.vcArr indexOfObject:self.pageViewController.viewControllers.firstObject];
    if (index != NSNotFound) {
        [self.headTabView setSelectedSegmentIndex:index animated:YES];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.vcArr indexOfObject:viewController];
    if (index >= self.vcArr.count || index <= 0 || index == NSNotFound) {
        return nil;
    }
    
    return [self.vcArr objectAtIndex:index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.vcArr indexOfObject:viewController];
    if (index >= self.vcArr.count - 1) {
        return nil;
    }
    return [self.vcArr objectAtIndex:index + 1];
}


- (UIPageViewController *)pageViewController
{
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

- (HMSegmentedControl *)headTabView{
    if (!_headTabView) {
        
        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录

                
                NSString *one = @"待提箱";
                NSString *two = @"运输中";
                NSString *three = @"已完成";
                
                if (![NSString stringIsNilOrEmpty:self.countModel.wait_box]) {
                    one = [NSString stringWithFormat:@"待提箱(%@)",self.countModel.wait_box];
                }
                if (![NSString stringIsNilOrEmpty:self.countModel.transport]) {
                    two = [NSString stringWithFormat:@"运输中(%@)",self.countModel.transport];
                }
                if (![NSString stringIsNilOrEmpty:self.countModel.completed]) {
                    three = [NSString stringWithFormat:@"已完成(%@)",self.countModel.completed];
                }
                _headTabView = [[HMSegmentedControl alloc] initWithSectionTitles:@[one,two,three]];
                
                
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录
                NSString *one = @"已接单";
                NSString *two = @"运输中";
                NSString *three = @"已进港";

                if (![NSString stringIsNilOrEmpty:self.countModel.allotted]) {
                    one = [NSString stringWithFormat:@"已接单(%@)",self.countModel.allotted];
                }

                if (![NSString stringIsNilOrEmpty:self.countModel.under_way]) {
                    two = [NSString stringWithFormat:@"运输中(%@)",self.countModel.under_way];
                }
                _headTabView = [[HMSegmentedControl alloc] initWithSectionTitles:@[one,two,three]];
                
                
            }
        }else {
            //   未登录
            
            NSString *one = @"待提箱";
            NSString *two = @"运输中";
            NSString *three = @"已完成";
            
            if (![NSString stringIsNilOrEmpty:self.countModel.wait_box]) {
                one = [NSString stringWithFormat:@"待提箱(%@)",self.countModel.wait_box];
            }
            if (![NSString stringIsNilOrEmpty:self.countModel.transport]) {
                two = [NSString stringWithFormat:@"运输中(%@)",self.countModel.transport];
            }
            if (![NSString stringIsNilOrEmpty:self.countModel.completed]) {
                three = [NSString stringWithFormat:@"已完成(%@)",self.countModel.completed];
            }
            _headTabView = [[HMSegmentedControl alloc] initWithSectionTitles:@[one,two,three]];
            
        }

        _headTabView.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _headTabView.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _headTabView.selectionIndicatorColor = RGB(26, 143, 241);
        _headTabView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _headTabView.selectionIndicatorHeight = 2;
        [_headTabView setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
            UIColor *textColor;
            if (selected) {
                textColor = RGB(26, 143, 241);
            } else {
                textColor = RGB(162, 162, 162);
            }
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:[UIFont systemFontOfSize:SizeWidth(15)]}];
            return attString;
        }];
    }
    return _headTabView;
}

- (NSArray *)vcArr{
    if (!_vcArr) {
        
        if ([ConfigModel getBoolObjectforKey:IsLogin]) {
            if ([ConfigModel getBoolObjectforKey:DriverLogin]) {
                //   司机登录
                JYBOrderSingleVC *WaitTiVC = [[JYBOrderSingleVC alloc] init];
                WaitTiVC.type = JYBOrderTypeWaitTi;
                
                JYBOrderSingleVC *TransingVC = [[JYBOrderSingleVC alloc] init];
                TransingVC.type = JYBOrderTypeTransing;
                
                JYBOrderSingleVC *OverVC = [[JYBOrderSingleVC alloc] init];
                OverVC.type = JYBOrderTypeOver;
                
                
                _vcArr = @[WaitTiVC,TransingVC,OverVC];
            }
            if ([ConfigModel getBoolObjectforKey:WorkLogin]) {
                //  装箱工登录

                JYBOrderSingleVC *attendVC = [[JYBOrderSingleVC alloc] init];
                attendVC.type = JYBOrderTypeAllotted;
                
                JYBOrderSingleVC *TransingVC = [[JYBOrderSingleVC alloc] init];
                TransingVC.type = JYBOrderTypeTransing;
                
                JYBOrderSingleVC *OverVC = [[JYBOrderSingleVC alloc] init];
                OverVC.type = JYBOrderTypeInPort;
                
                _vcArr = @[attendVC,TransingVC,OverVC];
            }
        }else {
            //   未登录
            
            JYBOrderSingleVC *WaitTiVC = [[JYBOrderSingleVC alloc] init];
            WaitTiVC.type = JYBOrderTypeAllotted;
            
            JYBOrderSingleVC *TransingVC = [[JYBOrderSingleVC alloc] init];
            TransingVC.type = JYBOrderTypeTransing;
            
            JYBOrderSingleVC *OverVC = [[JYBOrderSingleVC alloc] init];
            OverVC.type = JYBOrderTypeInPort;
            
            
            _vcArr = @[WaitTiVC,TransingVC,OverVC];
        }
        

    }
    return _vcArr;
}


@end
