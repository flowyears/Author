//
//  MMSystemAuthorManager.h
//  Author
//
//  Created by boolean on 17/6/21.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSystemAuthorMacros.h"

@interface MMSystemAuthorManager : NSObject
+ (MMSystemAuthorManager *)shareInstance;

#pragma mark - 相册
/**
 相册权限
 */
+ (void)authorCheckForAlbum:(GrantBlock)grantBlock;

#pragma mark - 相机

/**
 相机权限
 */
+ (void)authorCheckForVideo:(GrantBlock)grantBlock;

#pragma mark - 麦克风
/**
 麦克风权限
 */
+ (void)authorCheckForAudio:(GrantBlock)grantBlock;
+ (void)authorCheckForAudio1:(GrantBlock)grantBlock;//两种方法是等价的，可以任选一种使用

#pragma mark - 日历
/**
 日历权限
 */
+ (void)authorCheckForEvent:(GrantBlock)grantBlock;

#pragma mark - 备忘录
/**
 备忘录权限
 */
+ (void)authorCheckForReminder:(GrantBlock)grantBlock;

#pragma mark - 通讯录
/**
 通讯录权限
 */
+ (void)authorCheckForContact:(GrantBlock)grantBlock;

#pragma mark - 定位
/**
 定位权限
 */
+ (void)authorCheckForLocation:(GrantBlock)grantBlock;
#pragma mark - Class Method
+ (NSString *)appName;
+ (void)showAuthorTipsWithTitle:(NSString *)title message:(NSString *)message;
@end
