//
//  MMNotificationAuthorManager.h
//  Author
//
//  Created by boolean on 17/6/23.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMNotificationAuthorManager : NSObject
+ (instancetype)shareInstance;
- (void)authorCheckForNotification;
@end
