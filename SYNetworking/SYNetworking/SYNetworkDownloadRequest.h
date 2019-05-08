//
//  SYNetworkDownloadRequest.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/8.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkBaseRequest.h"

@interface SYNetworkDownloadRequest : SYNetworkBaseRequest

-(void)sendDownloadRequest:(NSString*)url
        downloadFilePath:(NSString *_Nonnull)downloadFilePath
        progress:(SYProgressBlock _Nullable)downloadProgressBlock
        success:(SYCompletionBlock _Nullable)downloadSuccessBlock
        failure:(SYCompletionBlock _Nullable)downloadFailureBlock;

@end

