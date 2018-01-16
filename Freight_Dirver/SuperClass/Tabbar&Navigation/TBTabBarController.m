//
//  TBTabBarController.m
//  TabbarBeyondClick
//
//  Created by 卢家浩 on 2017/4/17.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "TBTabBarController.h"
#import "FirstViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import "TBNavigationController.h"

@interface TBTabBarController ()

@end

@implementation TBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化所有控制器
    [self setUpChildVC];
    
//    // 创建tabbar中间的tabbarItem
//    [self setUpMidelTabbarItem];
    
}

#pragma mark -创建tabbar中间的tabbarItem 

//- (void)setUpMidelTabbarItem {
//
//    TBTabBar *tabBar = [[TBTabBar alloc] init];
//    [self setValue:tabBar forKey:@"tabBar"];
//
//    __weak typeof(self) weakSelf = self;
//    [tabBar setDidClickPublishBtn:^{
//
////        TBPlusViewController *hmpositionVC = [[TBPlusViewController alloc] init];
////        TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:hmpositionVC];
////        [weakSelf presentViewController:nav animated:YES completion:nil];
//
//    }];
//
//}

#pragma mark -初始化所有控制器 

- (void)setUpChildVC {

    FirstViewController *first = [[FirstViewController alloc] init];
    [self setChildVC:first title:@"首页" image:@"tab_icon_dd" selectedImage:@"tab_icon_dd_pre"];
    MessageViewController *fishpidVC = [[MessageViewController alloc] init];
    [self setChildVC:fishpidVC title:@"消息" image:@"tab_icon_xx" selectedImage:@"tab_icon_xx_pre"];
    MeViewController *messageVC = [[MeViewController alloc] init];
    [self setChildVC:messageVC title:@"我的" image:@"tab_icon_wd" selectedImage:@"tab_icon_wd_pre"];

}

- (void) setChildVC:(UIViewController *)childVC title:(NSString *) title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    TBNavigationController *nav = [[TBNavigationController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"item name = %@", item.title);
    NSInteger index = [self.tabBar.items indexOfObject:item];
    [self animationWithIndex:index];
    if([item.title isEqualToString:@"发现"])
    {
        // 也可以判断标题,然后做自己想做的事<img alt="得意" src="http://static.blog.csdn.net/xheditor/xheditor_emot/default/proud.gif" />
    }
}
- (void)animationWithIndex:(NSInteger) index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.duration = 0.2;
    pulse.repeatCount= 1;
    pulse.autoreverses= YES;
    pulse.fromValue= [NSNumber numberWithFloat:0.7];
    pulse.toValue= [NSNumber numberWithFloat:1.3];
    [[tabbarbuttonArray[index] layer] 
     addAnimation:pulse forKey:nil]; 
}

@end
