//
//  AppDelegate.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
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
