//
//  XHApiClient.m
//  XHSocial
//
//  Created by 曾 宪华 on 13-12-6.
//  Copyright (c) 2013年 嗨，我是曾宪华(@xhzengAIB)，曾加入YY Inc.担任高级移动开发工程师，拍立秀App联合创始人，热衷于简洁、而富有理性的事物 QQ:543413507 主页:http://zengxianhua.com All rights reserved.
//

#import "XHApiClient.h"

@implementation XHApiClient
+ (XHApiClient *)sharedClient {
    static XHApiClient *sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[XHApiClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    
    return sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"Accept" value:@"text/json"];
    }
    
    return self;
}

- (void)POSTRequestForPathName:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
         failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    request.timeoutInterval = kTimeoutInterval;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)GETRequestForPathName:(NSString *)path
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    request.timeoutInterval = kTimeoutInterval;
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:operation];
}
@end
