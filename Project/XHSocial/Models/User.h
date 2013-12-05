//
//  User.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * constellation;
@property (nonatomic, retain) NSDate * createdate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * objectid;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * sina_token;
@property (nonatomic, retain) NSString * sina_token_secret;
@property (nonatomic, retain) NSString * tencent_token;
@property (nonatomic, retain) NSString * tencent_token_secret;
@property (nonatomic, retain) NSString * username;

@end
