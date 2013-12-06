//
//  XHAccountManagerHeader.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#ifndef XHSocial_XHAccountManagerHeader_h
#define XHSocial_XHAccountManagerHeader_h

#import "User.h"

typedef void(^LoginCompleted)(User *loginUser, UIViewController *didLoginCompleteViewController);

typedef NS_ENUM(NSInteger, LoginType) {
    kSina = 0,
    kTencent,
    kUserNameSetter,
    kEmailRegisted,
    kSignin,
    kResetPassword
};

#endif
