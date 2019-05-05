//
//  SYNetworkRequestPool.h
//  SYNetworking
//
//  Created by Sylar on 2019/4/30.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetworkHeader.h"

@class SYNetworkBaseRequest;

//Store Request
typedef NSMutableDictionary<NSString *, SYNetworkBaseRequest *> SYCurrentAllRequests;

@interface SYNetworkRequestPool : NSObject

+ (SYNetworkRequestPool *)sharedPool;

/**
 
 *  Return All Current Request
 *  Request Models Set In NSDictionary
 */
- (SYCurrentAllRequests *_Nonnull)currentAllRequests;


- (SYNetworkBaseRequest * )requestWithTaskID:(NSString*)taskID;


/**
 *  This method is used to add a request model into current request models set
 */
- (void)addRequest:(SYNetworkBaseRequest *)request;



/**
 *  This method is used to remove a request model from current request models set
 */
- (void)removeRequest:(SYNetworkBaseRequest *)request;


- (void)removeAllRequest;


/**
 *  check if have request
 */
- (BOOL)remainingCurrentRequests;



/**
 *  check count of remaining requests
 */
- (NSInteger)currentRequestCount;
@end


