//
//  ReviewViewController.h
//  Freight_Company
//
//  Created by cc on 2018/1/16.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum ReviewType {
    Reviewing = 0 ,// 审核中
    ReviewError = 1 // 审核失败
}ReviewType;

@interface ReviewViewController : CCBaseViewController

@property (nonatomic , assign) ReviewType type;

@end
