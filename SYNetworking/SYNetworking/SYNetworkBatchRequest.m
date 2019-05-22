//
//  SYNetworkBatchRequest.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/16.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkBatchRequest.h"
#import "SYNetworkPrivate.h"
#import "SYNetworkBatchRequestManager.h"
#import "SYNetworkBaseRequest.h"

@interface SYNetworkBatchRequest ()<SYNetworkRequestDelegate>
@property (nonatomic) NSInteger finishedCount;
@end

@implementation SYNetworkBatchRequest
- (instancetype)initWithRequestArray:(NSArray<SYNetworkBaseRequest *> *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (SYNetworkBaseRequest * req in _requestArray) {
            if (![req isKindOfClass:[SYNetworkBaseRequest class]]) {
                
                return nil;
            }
        }
    }
    return self;
}


- (void)start {
    if (_finishedCount > 0) {
        return;
    }
    _failedRequest = nil;
    [[SYNetworkBatchRequestManager sharedManager] addBatchRequest:self];
    for (SYNetworkBaseRequest * req in _requestArray) {
        req.delegate = self;
        [req clearCompletionBlock];
        [req start];
    }
}

- (void)stop {
    _delegate = nil;
    [self clearRequest];
    [[SYNetworkBatchRequestManager sharedManager] removeBatchRequest:self];
}

- (void)clearRequest {
    for (SYNetworkBaseRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}


#pragma mark - Network Request Delegate
- (void)requestFinished:(__kindof SYNetworkBaseRequest *)request{
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        [[SYNetworkBatchRequestManager sharedManager] removeBatchRequest:self];
    }
}

- (void)requestFailed:(__kindof SYNetworkBaseRequest *)request{
    _failedRequest = request;

    // Stop
    for (SYNetworkBaseRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    // Clear
    [self clearCompletionBlock];
    
    [[SYNetworkBatchRequestManager sharedManager] removeBatchRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(SYNetworkBatchRequest *))success failure:(void (^)(SYNetworkBatchRequest *))failure{
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(SYNetworkBatchRequest *))success failure:(void (^)(SYNetworkBatchRequest *))failure{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}
@end
