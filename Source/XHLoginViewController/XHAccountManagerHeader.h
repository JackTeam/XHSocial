//
//  XHAccountManagerHeader.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#ifndef XHSocial_XHAccountManagerHeader_h
#define XHSocial_XHAccountManagerHeader_h

#import "User.h"

typedef void(^LoginCompleted)(User *loginUser, UIViewController *didLoginCompleteViewController);

typedef NS_ENUM(NSInteger, PickerUserAvatarType) {
    kCapturePhoto = 0,
    kLibrary
};

typedef NS_ENUM(NSInteger, LoginType) {
    kSina = 0,
    kTencent,
    kUserNameSetter,
    kEmailRegisted,
    kSignin,
    kResetPassword
};

#endif
