//
//  User.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-5.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic age;
@dynamic constellation;
@dynamic createdate;
@dynamic email;
@dynamic objectid;
@dynamic password;
@dynamic sina_token;
@dynamic sina_token_secret;
@dynamic tencent_token;
@dynamic tencent_token_secret;
@dynamic username;

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.username, @"username",
                                    self.password, @"password",
                                    self.constellation, @"constellation",
                                    self.email, @"email",
                                    nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}

@end
