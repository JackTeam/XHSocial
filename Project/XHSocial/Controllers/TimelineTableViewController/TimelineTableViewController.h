//
//  TimelineTableViewController.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "User.h"

@interface TimelineTableViewController : RootViewController
@property (nonatomic, strong) User *loginUser;
@end
