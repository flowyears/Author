//
//  MMNotificationAuthorManager.m
//  Author
//
//  Created by boolean on 17/6/23.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "MMNotificationAuthorManager.h"
#import <UIKit/UIKit.h>
#import "MMSystemAuthorMacros.h"
#import "MMSystemAuthorManager.h"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface MMNotificationAuthorManager ()<UNUserNotificationCenterDelegate>

@end
@implementation MMNotificationAuthorManager
+ (instancetype)shareInstance
{
    static MMNotificationAuthorManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[MMNotificationAuthorManager alloc] init];
    });
    return _shareInstance;
}

- (void)authorCheckForNotification
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
[center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
    switch (settings.authorizationStatus)
    {
        case UNAuthorizationStatusNotDetermined:
        {
            [self registerRemoteNotification];
        }
            break;
        case UNAuthorizationStatusAuthorized:
        {//已授权
            
        }
            break;
        case UNAuthorizationStatusDenied:
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭定位权限",[MMSystemAuthorManager appName]];
            NSString *msg = @"您可以在\"设置\"中为此应用打开通知权限";
            [MMSystemAuthorManager showAuthorTipsWithTitle:title message:msg];
        }
            break;
        default:
            break;
    }
}];
#else
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (settings.types) {
        case UIUserNotificationTypeNone:
        {
            NSNumber *hasRequestNotificationAuthor =  [[NSUserDefaults standardUserDefaults] objectForKey:HAS_REQUEST_NOTIFICAITON_AUTHOR];
            if (hasRequestNotificationAuthor)
            {//说明请求过，但是被拒绝了
                NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭定位权限",[MMSystemAuthorManager appName]];
                NSString *msg = @"您可以在\"设置\"中为此应用打开通知权限";
                [MMSystemAuthorManager showAuthorTipsWithTitle:title message:msg];
            }
            else
            {//还未请求过
                [self registerRemoteNotification];
            }
        }
            break;
        case UIUserNotificationTypeAlert:
        case UIUserNotificationTypeBadge:
        case UIUserNotificationTypeSound:
        {
            
        }
            break;
            
        default:
            break;
    }
#endif
    
    
    
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                             UNAuthorizationOptionSound |
                                             UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
                              [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:HAS_REQUEST_NOTIFICAITON_AUTHOR];
                          }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else
        UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                        UIUserNotificationTypeSound |
                                        UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    /* 在注册完回调函数中添加是否注册成功的标记：
     [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ALLOW_OPEN_NOTIFICAITON];*/
#endif
   
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge |
                      UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    //[GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif
@end
