//
//  SYNetworkDownloadRequest.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/8.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkDownloadRequest.h"

@implementation SYNetworkDownloadRequest
@synthesize requestURL = _requestURL;
@synthesize successBlock = _successBlock;
@synthesize failureBlock = _failureBlock;
@synthesize downloadProgressBlock = _downloadProgressBlock;
@synthesize resumableDownloadPath = _resumableDownloadPath;
@synthesize isResumable = _isResumable;
- (SYRequestType)requestType{
    return SYRequestTypeDownload;
}

- (void)sendDownloadRequest:(NSString *)url downloadFilePath:(NSString *)downloadFilePath progress:(SYProgressBlock)downloadProgressBlock success:(SYCompletionBlock)downloadSuccessBlock failure:(SYCompletionBlock)downloadFailureBlock{
    [self sendDownloadRequest:url resumable:YES downloadFilePath:downloadFilePath progress:downloadProgressBlock success:downloadSuccessBlock failure:downloadFailureBlock];
}

- (void)sendDownloadRequest:(NSString *)url resumable:(BOOL)resumable downloadFilePath:(NSString *)downloadFilePath progress:(SYProgressBlock)downloadProgressBlock success:(SYCompletionBlock)downloadSuccessBlock failure:(SYCompletionBlock)downloadFailureBlock{
    _requestURL = url;
    _resumableDownloadPath = downloadFilePath;
    _successBlock = downloadSuccessBlock;
    _failureBlock = downloadFailureBlock;
    _downloadProgressBlock = downloadProgressBlock;
    _isResumable = resumable;
    [super start];
}

@end
