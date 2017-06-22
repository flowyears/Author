//
//  MMLocationAuthorManager.h
//  Author
//
//  Created by boolean on 17/6/22.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSystemAuthorMacros.h"

@interface MMLocationAuthorManager : NSObject
+ (instancetype)shareInstance;
- (void)authorCheckForLocation:(GrantBlock)grantBlock;
@end
