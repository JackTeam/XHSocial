//
//  XHParallaxNavigationController.h
//  iyilunba
//
//  Created by 曾 宪华 on 13-12-4.
//  Copyright (c) 2013年 曾 宪华 开发团队(http://iyilunba.com ). All rights reserved.
//

#import <UIKit/UIKit.h>

// 背景视图起始frame.x
#define startX -200;

@interface XHParallaxNavigationController : UINavigationController
// 静态栏 默认是显示的
@property (nonatomic, assign) BOOL hideStatusBar;
// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
// 默认为毛玻璃不开启
@property (nonatomic, assign) BOOL isBlurry;
@end

@interface UIViewController (XHParallaxNavigationController)
- (XHParallaxNavigationController *)xh_parallaxNavigationController;
@end