//
//  User.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
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
