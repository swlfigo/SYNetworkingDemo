//
//  SYNetworkBaseRequest.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/2.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkBaseRequest.h"
#import "SYNetworkManager.h"
#import "SYNetworkConfig.h"

@interface SYNetworkBaseRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseJSONObject;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSString *responseString;
@property (nonatomic, strong, readwrite) NSError *error;
@end

@implementation SYNetworkBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestURL = @"";
        _requestMethod = SYRequestMethodGET;
        _responseSerializerType = SYResponseSerializerTypeJSON;
        _requestSerializerType = SYRequestSerializerTypeHTTP;
        _requestTimeoutInterval = [SYNetworkConfig sharedConfig].timeoutSeconds;
        _allowsCellularAccess = YES;
    }
    return self;
}

- (void)clearCompletionBlock{
    _successBlock = nil;
    _failureBlock = nil;
    _uploadProgressBlock = nil;
    _downloadProgressBlock = nil;
}


- (NSHTTPURLResponse *)response {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}


- (void)start{
    [[SYNetworkManager sharedManager]addRequest:self];
}

- (void)stop{
    [[SYNetworkManager sharedManager]cancelRequest:self];
}



@end
