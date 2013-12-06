//
//  XHApiClient.h
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-6.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "AFHTTPClient.h"

@interface XHApiClient : AFHTTPClient

+ (XHApiClient *)sharedClient;

- (void)POSTRequestForPathName:(NSString *)path
        parameters:(NSDictionary *)parameters
           success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
           failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

- (void)GETRequestForPathName:(NSString *)path
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
@end
