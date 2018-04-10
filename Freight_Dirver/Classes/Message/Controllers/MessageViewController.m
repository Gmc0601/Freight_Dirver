//
//  MessageViewController.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/15.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "MessageViewController.h"
#import <YYKit.h>
#import "SystemMessageViewController.h"
#import "ChoseMembersViewController.h"
#import "EaseMessageViewController.h"

@implementation MessageModel

@end

@interface MessageViewController ()<UITableViewDelegate,  UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigation];
    [self.view addSubview:self.noUseTableView];
}

- (void)getDate {
    EMError *error = nil;
    NSString *userId = [NSString stringWithFormat:@"d%@", [ConfigModel getStringforKey:DriverId]];
    error = [[EMClient sharedClient] loginWithUsername:userId password:ChatPWD];
    [self.dataArr removeAllObjects];
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    self.dataArr = (NSMutableArray *)conversations;
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EMConversation *conversation = obj;
        EMMessage *message = conversation.latestMessage;
        if ([[self timeStr:message.localTime] isEqualToString:@"1970-01-01 08:00"]) {
            [self.dataArr removeObject:obj];
        }
    }];
    
    NSString *arrimg ;   //  聊天 Id  拼接
    NULLReturn(conversations);
    for (int i = 0; i < conversations.count; i++) {
        EMConversation *conversation = conversations[i];
        NSString *imgStr = conversation.conversationId;
        
        if (i == 0) {
            arrimg = imgStr;
        }else {
            NSString *str = [NSString stringWithFormat:@",%@", imgStr];
            arrimg = [arrimg stringByAppendingString:str];
        }
    }
    NSDictionary *dic =@{
                         @"driver_ids" : arrimg
                         };
    [HttpRequest postPath:@"Driver/Public/batchDriverInfo" params:dic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"success"] intValue] == 1) {
            
            
        }else {
            NSString *str = datadic[@"msg"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
    
    
}
- (NSString *)timeStr:(long long)timestamp
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    
    // 获取当前时间的年、月、日
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger currentYear = components.year;
    NSInteger currentMonth = components.month;
    NSInteger currentDay = components.day;
    
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    CGFloat msgYear = components.year;
    CGFloat msgMonth = components.month;
    CGFloat msgDay = components.day;
    
    // 判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    if (currentYear == msgYear && currentMonth == msgMonth && currentDay == msgDay) {
        //今天
        dateFmt.dateFormat = @"HH:mm";
    }else if (currentYear == msgYear && currentMonth == msgMonth && currentDay-1 == msgDay ){
        //昨天
        dateFmt.dateFormat = @"昨天 HH:mm";
    }else{
        //昨天以前
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [dateFmt stringFromDate:msgDate];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![ConfigModel getBoolObjectforKey:IsLogin]) {
        ChoseMembersViewController *vc = [[ChoseMembersViewController alloc] init];
        vc.backBlock = ^{
            self.tabBarController.selectedIndex = 0;
        };
        
        UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:nil];
        return;
    }
    [self getDate];
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

- (void)backAction {
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section ? self.dataArr.count : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%d", indexPath.row];
    UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@"xxzx_icon_xtxx"];
            cell.textLabel.text = @"系统消息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            UIButton *message , *callBtn;
            message = [[UIButton alloc] initWithFrame:FRAME(SizeWidth(260), 24, 34, 34)];
            message.backgroundColor = [UIColor clearColor];
            [message setImage:[UIImage imageNamed:@"ddxq_icon_lt_68 (1)"] forState:UIControlStateNormal];
            message.tag = 100 + indexPath.row;
            [message addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:message];
            
            callBtn = [[UIButton alloc] initWithFrame:FRAME(message.right + SizeWidth(15), 24, 34, 34)];
            callBtn.backgroundColor = [UIColor clearColor];
            callBtn.tag = 1000 + indexPath.row;
            [callBtn setImage:[UIImage imageNamed:@"ddxq_icon_dh_68 (1)"] forState:UIControlStateNormal];
            [callBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:callBtn];
            cell.imageView.image = [UIImage imageNamed:@"xxzx_icon_96 (1)"];
            cell.textLabel.text = @"你好";
        }
        if (indexPath.section) {
            UILabel *line = [[UILabel alloc] initWithFrame:FRAME(15, 81, kScreenW, 1)];
            line.backgroundColor = UIColorHex(0xe3e3e3);
            [cell.contentView addSubview:line];
        }

        [cell.imageView sizeToFit];
        
        
    }
    return cell;
}

- (void)btnClick:(UIButton *)sender {
    int tag = sender.tag;
    
    if (tag < 1000) {
        //  message
        EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"8800" conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
        
        
    }else {
        
        //  call
    }
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[SystemMessageViewController new] animated:YES];
    }
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
        _noUseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, SizeHeight(15))];
            UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeight(15))];
            lab.backgroundColor = [UIColor clearColor];
            lab.font = [UIFont systemFontOfSize:12];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = UIColorFromHex(0x999999);
            [view addSubview:lab];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  0)];
            
            view;
        });
    }
    return _noUseTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

@end
