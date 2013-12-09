//
//  AppDelegate.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  
 
 #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
 #endif
 这个判断方式只对方法或者属性定义之类进行，而不是函数内的具体方法和属性设置进行判断
 */

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@end
