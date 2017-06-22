//
//  UtilTool.m
//  Author
//
//  Created by boolean on 17/6/22.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "UtilTool.h"


@implementation UtilTool
+ (UIImage *)appIcon
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    UIImage* image = [UIImage imageNamed:icon];
    return image;
}

+ (NSString *)appName
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [infoPlist valueForKeyPath:@"CFBundleDisplayName"];

    return appName;
}
@end
