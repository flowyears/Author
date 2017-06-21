//
//  MMSystemAuthorManager.m
//  Author
//
//  Created by boolean on 17/6/21.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "MMSystemAuthorManager.h"
#import <AVFoundation/AVFoundation.h>//相机权限
#import <Photos/Photos.h>//相册权限
#import <CoreTelephony/CTCellularData.h>
#import <Contacts/Contacts.h>
#import "UIAlertController+Window.h"
#import "MMSystemAuthorMacros.h"

@implementation MMSystemAuthorManager
#pragma mark - Life Cycle
+ (MMSystemAuthorManager *)shareInstance
{
    static MMSystemAuthorManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[MMSystemAuthorManager alloc] init];
    });
    return _shareInstance;
}

#pragma mark - Class Method
+ (void)authorCheckForAlbum:(GrantBlock)grantBlock
{
   __block BOOL isAuthor = NO;
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    
    switch (photoAuthorStatus)
    {
        case PHAuthorizationStatusNotDetermined:
        {//还未对此app权限做出选择
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized)
                {
                    // 用户同意授权
                    isAuthor = YES;
                }
                else
                {
                    // 用户拒绝授权
                }
            }];
            if (grantBlock)
            {
                grantBlock(isAuthor);
            }
            return;
        }
            break;
        case PHAuthorizationStatusDenied://用户已明确拒绝此应用程序对照片数据的访问。
        case PHAuthorizationStatusRestricted://此应用程序没有权限访问照片数据。用户不能更改应用程序的状态，可能是由于活动限制。(比如家长控制（网上说的）)
        {
            //未授权
            [[self class] showAuthorTipsWithTitle:@"已为\"家校帮\"关闭相册权限" message:@"您可以在\"设置\"中为此应用打开相册权限"];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {//已授权
            isAuthor = YES;
        }
            break;
            
        default:
            break;
    }
    if (grantBlock)
    {
        grantBlock(isAuthor);
    }
    return;
}



//跳转到app设置
+ (void)openAppSettings
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
#endif
}
+ (void)showAuthorTipsWithTitle:(NSString *)title message:(NSString *)message
{
    //未授权
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"知道了"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                         }];
    
    
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"去开启"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [[self class] openAppSettings];
                                                     }];
    
    
    
    [alertController addAction:actionCancel];
    [alertController addAction:actionOK];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertController show];
    });
}
@end
