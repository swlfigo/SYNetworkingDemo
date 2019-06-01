//
//  SYNetworkRequest.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/2.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkBaseRequest.h"

/**
 * Use For Base Request - GET,POST,Put,Delete,HEAD
 */
@interface SYNetworkRequest : SYNetworkBaseRequest

- (void)sendRequest:(NSString * _Nonnull)url
        success:(SYCompletionBlock _Nullable)successBlock
        failure:(SYCompletionBlock _Nullable)failureBlock;

- (void)sendRequest:(NSString * _Nonnull)url
        parameters:(NSDictionary*)parameters
        success:(SYCompletionBlock _Nullable)successBlock
        failure:(SYCompletionBlock _Nullable)failureBlock;

- (void)sendPostRequest:(NSString * _Nonnull)url
        parameters:(NSDictionary*)parameters
        constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
        success:(SYCompletionBlock _Nullable)successBlock
        failure:(SYCompletionBlock _Nullable)failureBlock;


@end

