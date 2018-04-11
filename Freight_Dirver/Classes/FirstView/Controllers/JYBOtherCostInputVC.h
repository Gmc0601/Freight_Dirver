//
//  JYBOtherCostInputVC.h
//  Freight_Dirver
//
//  Created by ToneWang on 2018/4/11.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "JYBOrderListModel.h"


@protocol JYBOtherCostInputVCDelegate <NSObject>

- (void)JYBOtherCostInputSuccess;

@end

@interface JYBOtherCostInputVC : CCBaseViewController

@property (nonatomic ,weak)id <JYBOtherCostInputVCDelegate>delegate;

@property (nonatomic ,strong)JYBOrderListModel *detailModel;

@end
