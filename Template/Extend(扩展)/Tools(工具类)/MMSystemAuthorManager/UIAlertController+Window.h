//
//  UIAlertController+Window.h
//  Communication
//
//  Created by mac on 2017/6/13.
//  Copyright © 2017年 whty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIAlertController (Window)
- (void)show;
- (void)show:(BOOL)animated;
@end


@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end
