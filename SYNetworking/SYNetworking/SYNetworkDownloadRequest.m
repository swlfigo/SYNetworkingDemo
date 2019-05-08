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

- (SYRequestType)requestType{
    return SYRequestTypeDownload;
}

- (void)sendDownloadRequest:(NSString *)url downloadFilePath:(NSString *)downloadFilePath progress:(SYProgressBlock)downloadProgressBlock success:(SYCompletionBlock)downloadSuccessBlock failure:(SYCompletionBlock)downloadFailureBlock{
    _requestURL = url;
    _resumableDownloadPath = downloadFilePath;
    _successBlock = downloadSuccessBlock;
    _failureBlock = downloadFailureBlock;
    _downloadProgressBlock = downloadProgressBlock;
    [super start];
}

@end
