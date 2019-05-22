//
//  SYNetworkBatchRequestManager.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/16.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  SYNetworkBatchRequest;
@interface SYNetworkBatchRequestManager : NSObject

/**
 * SYNetworkManager Singleton
 */
+ (SYNetworkBatchRequestManager *_Nullable)sharedManager;


/**
 *  Add Request
 */
- (void)addBatchRequest:(SYNetworkBatchRequest*)request;

///  Cancel a request that was previously added.
- (void)removeBatchRequest:(SYNetworkBatchRequest *)request;




@end


