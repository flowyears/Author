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
#import <EventKit/EventKit.h>//日历备忘录
#import "MMLocationAuthorManager.h"
#import "MMNotificationAuthorManager.h"
#import "UIAlertController+Window.h"


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
#pragma mark - 相册
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
                {// 用户同意授权
                    isAuthor = YES;
                }
                else
                {// 用户拒绝授权
                }
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            }];
            return;
        }
            break;
        case PHAuthorizationStatusDenied://用户已明确拒绝此应用程序对照片数据的访问。
        case PHAuthorizationStatusRestricted://此应用程序没有权限访问照片数据。用户不能更改应用程序的状态，可能是由于活动限制。(比如家长控制（网上说的）)
        {//未授权
            NSString *appName = [[self class] appName];
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭相册权限",appName];
            
            [[self class] showAuthorTipsWithTitle:title
                                          message:@"您可以在\"设置\"中为此应用打开相册权限"];
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
}

#pragma mark - 相机
+ (void)authorCheckForVideo:(GrantBlock)grantBlock
{
    [[self class] authorCheckForMediaType:AVMediaTypeVideo grantBlock:grantBlock];
}
+ (void)authorCheckForMediaType:(NSString *)mediaType grantBlock:(GrantBlock)grantBlock
{
    __block BOOL isAuthor = NO;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    switch (authStatus)
    {
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            NSString *appName = [[self class] appName];
            NSString *typeName = @"";
            
            if ([mediaType isEqualToString:AVMediaTypeAudio])
            {
                typeName = @"相机";
            }
            else if ([mediaType isEqualToString:AVMediaTypeVideo])
            {
                typeName = @"麦克风";
            }
            
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭%@权限",appName,typeName];
            NSString *msg = [NSString stringWithFormat:@"您可以在\"设置\"中为此应用打开%@权限",typeName];
            [[self class] showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                
                if (granted)
                {// 用户同意授权
                    isAuthor = YES;
                }
                else
                {// 用户拒绝授权
                }
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            }];
            return;
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
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
}
#pragma mark - 麦克风
+ (void)authorCheckForAudio:(GrantBlock)grantBlock
{
    [[self class] authorCheckForMediaType:AVMediaTypeAudio grantBlock:grantBlock];
}

+ (void)authorCheckForAudio1:(GrantBlock)grantBlock
{
   __block BOOL isAuthor = NO;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    switch (audioSession.recordPermission) {
        case AVAudioSessionRecordPermissionUndetermined:
        {
            [audioSession requestRecordPermission:^(BOOL granted) {
                if (granted)
                {// 用户同意授权
                    isAuthor = YES;
                }
                else
                {// 用户拒绝授权
                }
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            }];
            return;
        }
            break;
        case AVAudioSessionRecordPermissionDenied:
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭麦克风权限",[[self class] appName]];
            NSString *msg = @"您可以在\"设置\"中为此应用打开麦克风权限";
            [[self class] showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case AVAudioSessionRecordPermissionGranted:
        {
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
}

#pragma mark - 日历
+ (void)authorCheckForEvent:(GrantBlock)grantBlock
{
    [[self class] authorCheckForEKEntity:EKEntityTypeEvent grantBlock:grantBlock];
}

#pragma mark - 备忘录
+ (void)authorCheckForReminder:(GrantBlock)grantBlock
{
    [[self class] authorCheckForEKEntity:EKEntityTypeReminder grantBlock:grantBlock];
}
/**
 检测和获取日历与备忘权限
 
 @param eventType
 
 typedef NS_ENUM(NSUInteger, EKEntityType) {
 EKEntityTypeEvent,//日历
 EKEntityTypeReminder//备忘
 };
 
 */
+ (void)authorCheckForEKEntity:(EKEntityType)eventType grantBlock:(GrantBlock)grantBlock
{
   __block BOOL isAuthor = NO;
    EKAuthorizationStatus EKstatus = [EKEventStore  authorizationStatusForEntityType:eventType];
    switch (EKstatus) {
        case EKAuthorizationStatusAuthorized:
        {
            isAuthor = YES;
        }
            break;
        case EKAuthorizationStatusDenied:
            case EKAuthorizationStatusRestricted:
        {
            NSString *appName = [[self class] appName];
            NSString *typeName = @"";
            
            switch (eventType)
            {
                case EKEntityTypeEvent:
                {
                    typeName = @"日历";
                }
                    break;
                case EKEntityTypeReminder:
                {
                    typeName = @"备忘录";
                }
                    break;
                default:
                    break;
            }
            
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭%@权限",appName,typeName];
            NSString *msg = [NSString stringWithFormat:@"您可以在\"设置\"中为此应用打开%@权限",typeName];
            [[self class] showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case EKAuthorizationStatusNotDetermined:
        {
            EKEventStore *store = [[EKEventStore alloc]init];
            [store requestAccessToEntityType:eventType completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted)
                {
                isAuthor = YES;
                }
                else
                {}
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            }];
            return;
        }
            break;

        default:
            break;
    }
    if (grantBlock)
    {
        grantBlock(isAuthor);
    }
}

#pragma mark - 通讯录
+ (void)authorCheckForContact:(GrantBlock)grantBlock
{
    __block BOOL isAuthor = NO;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
        {
            isAuthor = YES;
        }
            break;
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted:
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭通讯录权限",[[self class] appName]];
            NSString *msg = @"您可以在\"设置\"中为此应用打开通讯录权限";
            [[self class] showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case CNAuthorizationStatusNotDetermined:
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                isAuthor = granted;
                
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            }];
            return;
        }
            break;
    }
#else
    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    switch (ABstatus) {
        case kABAuthorizationStatusAuthorized:
        {
            isAuthor = YES;
        }
            break;
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭通讯录权限",[[self class] appName]];
            NSString *msg = @"您可以在\"设置\"中为此应用打开通讯录权限";
            [[self class] showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted)
                {
                    isAuthor = YES;
                    CFRelease(addressBook);
                }
                else
                {}
                if (grantBlock)
                {
                    grantBlock(isAuthor);
                }
            });
            return;
        }
            break;
        default:
            break;
    }
#endif
    
    if (grantBlock)
    {
        grantBlock(isAuthor);
    }
}

#pragma mark - 定位
/**
 定位权限
 */
+ (void)authorCheckForLocation:(GrantBlock)grantBlock
{
    [[MMLocationAuthorManager shareInstance] authorCheckForLocation:grantBlock];
}

#pragma mark - 推送
/**
 推送权限
 */
+ (void)authorCheckForNotificaiton
{
    [[MMNotificationAuthorManager shareInstance] authorCheckForNotification];
}

#pragma mark - 网络权限检测
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
+ (void)authorCheckForNetwork:(GrantBlock)grantBlock
{
   __block BOOL isAuthor = NO;
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestricted://蜂窝权限被关闭，有 网络权限完全关闭 or 只有WiFi权限 两种情况
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭蜂窝网络权权限",[[self class] appName]];
            [[self class] showAuthorTipsWithTitle:title
                                          message:@"您可以在\"设置\"中为此应用打开蜂窝网络权权限"];
        }
            break;
        case kCTCellularDataNotRestricted://蜂窝权限开启
        {
            isAuthor = YES;
        }
            break;
            case kCTCellularDataRestrictedStateUnknown://权限未知
        {
        }
            break;
        default:
            break;
    }
    if (grantBlock)
    {
        grantBlock(isAuthor);
    }
}



/**
 实时监测联网状态
 */
+ (void)authorCheckNetworkMonitor
{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        //获取联网状态
        switch (state) {
            case kCTCellularDataRestricted:
            {
                NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭蜂窝网络权权限",[[self class] appName]];
                [[self class] showAuthorTipsWithTitle:title
                                              message:@"您可以在\"设置\"中为此应用打开蜂窝网络权权限"];
            }
                break;
            case kCTCellularDataNotRestricted:
                NSLog(@"Not Restricted");
                break;
            case kCTCellularDataRestrictedStateUnknown:
                NSLog(@"Unknown");
                break;
            default:
                break;
        };
    };
}

/*
 CTCellularData 使用时需要注意的关键点： 
 
 CTCellularData只能检测蜂窝权限，不能检测WiFi权限。
 一个CTCellularData实例新建时，restrictedState是kCTCellularDataRestrictedStateUnknown，之后在cellularDataRestrictionDidUpdateNotifier里会有一次回调，此时才能获取到正确的权限状态。
 当用户在设置里更改了app的权限时，cellularDataRestrictionDidUpdateNotifier会收到回调，如果要停止监听，必须将cellularDataRestrictionDidUpdateNotifier设置为nil。
 赋值给cellularDataRestrictionDidUpdateNotifier的block并不会自动释放，即便你给一个局部变量的CTCellularData实例设置监听，当权限更改时，还是会收到回调，所以记得将block置nil。
 */
#endif

#pragma mark - Class Method
+ (NSString *)appName
{

    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [infoPlist valueForKeyPath:@"CFBundleDisplayName"];
    
    return appName;
}
//跳转到app设置
+ (void)openAppSettings
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:nil];
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


//Denied: 用户已明确拒绝此应用程序对照片数据的访问。
//Restricted: 此应用程序没有权限访问照片数据。用户不能更改应用程序的状态，可能是由于活动限制。(比如家长控制（网上说的）)
