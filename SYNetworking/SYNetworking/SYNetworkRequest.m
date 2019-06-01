//
//  SYNetworkRequest.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/2.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkRequest.h"
#import "SYNetworkManager.h"

@implementation SYNetworkRequest
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize requestURL = _requestURL;
@synthesize requestArgument = _requestArgument;
@synthesize constructingBodyBlock = _constructingBodyBlock;
- (SYRequestType)requestType{
    return SYRequestTypeOrdinary;
}

- (void)sendRequest:(NSString *)url success:(SYCompletionBlock)successBlock failure:(SYCompletionBlock)failureBlock{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    _requestURL = url;
    [super start];
}

- (void)sendRequest:(NSString *)url parameters:(NSDictionary *)parameters success:(SYCompletionBlock)successBlock failure:(SYCompletionBlock)failureBlock{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    _requestURL = url;
    _requestArgument = parameters;
    [super start];
}


- (void)sendPostRequest:(NSString *)url parameters:(NSDictionary *)parameters constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock success:(SYCompletionBlock _Nullable)successBlock failure:(SYCompletionBlock _Nullable)failureBlock{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
    _constructingBodyBlock = constructingBodyBlock;
    _requestURL = url;
    _requestArgument = parameters;
    [super start];
}

@end
