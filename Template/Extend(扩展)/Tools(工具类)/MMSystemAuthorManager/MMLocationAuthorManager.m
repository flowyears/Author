//
//  MMLocationAuthorManager.m
//  Author
//
//  Created by boolean on 17/6/22.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "MMLocationAuthorManager.h"
#import <CoreLocation/CoreLocation.h>
#import "MMSystemAuthorManager.h"

@interface MMLocationAuthorManager ()
<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *manager;
@property(nonatomic,copy)GrantBlock grantedBlock;
@end
@implementation MMLocationAuthorManager
+ (instancetype)shareInstance
{
    static MMLocationAuthorManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[MMLocationAuthorManager alloc] init];
    });
    return _shareInstance;
}

- (void)authorCheckForLocation:(GrantBlock)grantBlock
{
    self.grantedBlock = grantBlock;
    __block BOOL isAuthor = NO;
    
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation)
    {
        if (grantBlock)
        {
            grantBlock(isAuthor);
        }
        return;
    }
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            isAuthor = YES;
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            NSString *title = [NSString stringWithFormat:@"已为\"%@\"关闭定位权限",[MMSystemAuthorManager appName]];
            NSString *msg = @"您可以在\"设置\"中为此应用打开定位权限";
            [MMSystemAuthorManager showAuthorTipsWithTitle:title message:msg];
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            //[self.manager requestAlwaysAuthorization];//一直获取定位信息
            [self.manager requestWhenInUseAuthorization];//使用的时候获取定位信息
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    __block BOOL isAuthor = NO;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            isAuthor = YES;
        }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
        
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
        
        }
            break;
        default:
            break;
    }
    if (self.grantedBlock)
    {
        self.grantedBlock(isAuthor);
    }
    
}

#pragma mark - Getter And Setting
- (CLLocationManager *)manager
{
    if (!_manager)
    {
        _manager = [[CLLocationManager alloc] init];
    }
    return _manager;
}
@end
