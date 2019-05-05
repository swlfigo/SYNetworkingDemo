//
//  SYNetworkManager.h
//  SYNetworking
//
//  Created by Sylar on 2019/4/29.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SYNetworkBaseRequest;
@interface SYNetworkManager : NSObject

/**
 * SYNetworkManager Singleton
 */
+ (SYNetworkManager *_Nullable)sharedManager;


/**
 *  Add Request
 */
- (void)addRequest:(SYNetworkBaseRequest*)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(SYNetworkBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;



@end


