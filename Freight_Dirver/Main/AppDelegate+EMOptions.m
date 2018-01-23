//
//  AppDelegate+EMOptions.m
//  Freight_Dirver
//
//  Created by cc on 2018/1/23.
//  Copyright © 2018年 cc. All rights reserved.
//

#import "AppDelegate+EMOptions.h"


@implementation AppDelegate (EMOptions)


- (void)initEmoptions {
   //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"1144171011115768#haichat"];
    options.apnsCertName = @"push";  //  push   正式    pushtext
    EMError *error  = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!error) {
        NSLog(@"初始化成功");
        
    }
    [self registerRemoteNotification];
//    [self jpush:launchOptions];
    
    //添加监听在线推送消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}


// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}


//   环信接受消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    //  设置未读数
//    message = YES;
//    int num = [ConfigModel getIntObjectforKey:Unreadnum];
//    num++;
//    [ConfigModel saveIntegerObject:num forKey:Unreadnum];
    
//    [UIApplication sharedApplication].applicationIconBadgeNumber = num;
    for (EMMessage *msg in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        // App在后台
        if (state == UIApplicationStateBackground) {
            //发送本地推送
            if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
                // 设置触发时间
//                havenewMessage++;
//                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
//                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//                content.sound = [UNNotificationSound defaultSound];
                // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”;
                //                content.badge = [NSNumber numberWithInteger:5];
//                NSString * str = [NSString stringWithFormat:@"您收到了%d条消息", havenewMessage];
//                content.body = str;
//                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:msg.messageId content:content trigger:trigger];
//                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
            }else {
//                havenewMessage++;
//                UILocalNotification *notification = [[UILocalNotification alloc] init];
//                notification.fireDate = [NSDate date]; //触发通知的时间
//                NSString * str = [NSString stringWithFormat:@"您收到了%d条消息", havenewMessage];
//                notification.alertBody = str;
//                notification.alertAction = @"Open";
//                notification.timeZone = [NSTimeZone defaultTimeZone];
//                notification.soundName = UILocalNotificationDefaultSoundName;
//                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:HaveNewMessage object:nil];
            
//            AudioServicesPlaySystemSound(1312);
            
            
        }
    }
}

@end
