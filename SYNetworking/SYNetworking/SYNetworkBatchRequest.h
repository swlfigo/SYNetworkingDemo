//
//  SYNetworkBatchRequest.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/16.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYNetworkBatchRequest;
@class SYNetworkBaseRequest;
@protocol SYNetworkBatchRequestDelegate <NSObject>

@optional

- (void)batchRequestFinished:(SYNetworkBatchRequest *)batchRequest;

- (void)batchRequestFailed:(SYNetworkBatchRequest *)batchRequest;

@end

@interface SYNetworkBatchRequest : NSObject

///  All the requests are stored in this array.
@property (nonatomic, strong, readonly) NSArray<SYNetworkBaseRequest *> *requestArray;

///  The delegate object of the batch request. Default is nil.
@property (nonatomic, weak, nullable) id<SYNetworkBatchRequestDelegate> delegate;

///  The success callback. Note this will be called only if all the requests are finished.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^successCompletionBlock)(SYNetworkBatchRequest *);

///  The failure callback. Note this will be called if one of the requests fails.
///  This block will be called on the main queue.
@property (nonatomic, copy, nullable) void (^failureCompletionBlock)(SYNetworkBatchRequest *);

///  Tag can be used to identify batch request. Default value is 0.
@property (nonatomic) NSInteger tag;

///  The first request that failed (and causing the batch request to fail).
@property (nonatomic, strong, readonly, nullable) SYNetworkBaseRequest *failedRequest;


- (instancetype)initWithRequestArray:(NSArray<SYNetworkBaseRequest *> *)requestArray;

///  Set completion callbacks
- (void)setCompletionBlockWithSuccess:(nullable void (^)(SYNetworkBatchRequest *batchRequest))success
                              failure:(nullable void (^)(SYNetworkBatchRequest *batchRequest))failure;

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;



///  Append all the requests to queue.
- (void)start;

///  Stop all the requests of the batch request.
- (void)stop;

///  Convenience method to start the batch request with block callbacks.
- (void)startWithCompletionBlockWithSuccess:(nullable void (^)(SYNetworkBatchRequest *batchRequest))success
                                    failure:(nullable void (^)(SYNetworkBatchRequest *batchRequest))failure;
@end


