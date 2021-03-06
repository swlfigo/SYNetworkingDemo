//
//  SYNetworkManager.m
//  SYNetworking
//
//  Created by Sylar on 2019/4/29.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkManager.h"
#import "SYNetworkRequestPool.h"
#import "SYNetworkConfig.h"
#import "SYNetworkBaseRequest.h"
#import "SYNetworkHeader.h"
#import "SYNetworkPrivate.h"
@interface SYNetworkManager ()


@end

@implementation SYNetworkManager{
    AFHTTPSessionManager *_sessionManager;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    SYNetworkConfig *_config;
}
//Singleton
+ (SYNetworkManager *)sharedManager{
    static SYNetworkManager *sharedManager = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes= [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        _config = [SYNetworkConfig sharedConfig];
    }
    return self;
}

- (void)addRequest:(SYNetworkBaseRequest *)request{
    
    //构建Request
    NSError * __autoreleasing requestSerializationError = nil;
    
    request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    
    if (requestSerializationError) {
        [self requestDidFailWithRequest:request error:requestSerializationError];
        return;
    }
    
    //save this request model into request set
    [[SYNetworkRequestPool sharedPool] addRequest:request];
    
    [request.requestTask resume];
}

- (NSURLSessionTask *)sessionTaskForRequest:(SYNetworkBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    //获得Request类型
    SYRequestMethod method = [request requestMethod];
    NSString *url = [request requestURL];
    id param = [request requestArgument];
    AFConstructingBlock constructingBlock = [request constructingBodyBlock];
    //配置Serializer
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    switch (method) {
        case SYRequestMethodGET:
            if (request.requestType == SYRequestTypeDownload) {
                //下载操作
                return [self downloadTaskWithBaseRequest:request DownloadPath:request.resumableDownloadPath requestSerializer:requestSerializer URLString:url parameters:param progress:request.resumableDownloadProgressBlock error:error];
            }else{
                //简单HTTP请求
                return [self dataTaskWithBaseRequest:request HTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:error];
            }
        case SYRequestMethodPOST:
            return  [self dataTaskWithBaseRequest:request HTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
        case SYRequestMethodHEAD:
            return [self dataTaskWithBaseRequest:request HTTPMethod:@"HEAD" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case SYRequestMethodPUT:
            return [self dataTaskWithBaseRequest:request HTTPMethod:@"PUT" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case SYRequestMethodDELETE:
            return [self dataTaskWithBaseRequest:request HTTPMethod:@"DELETE" requestSerializer:requestSerializer URLString:url parameters:param error:error];
        case SYRequestMethodPATCH:
            return [self dataTaskWithBaseRequest:request HTTPMethod:@"PATCH" requestSerializer:requestSerializer URLString:url parameters:param error:error];
    }
}


- (AFHTTPRequestSerializer *)requestSerializerForRequest:(SYNetworkBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == SYRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == SYRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    
    
    // If api needs to add custom value to HTTPHeaderField
    //先读取全局Custom Header
    NSDictionary<NSString *, NSString *> *globalCustomHeaderFieldValueDictionary = [SYNetworkConfig sharedConfig].customHeaders;
    if (globalCustomHeaderFieldValueDictionary && [globalCustomHeaderFieldValueDictionary isKindOfClass:[NSDictionary class]]) {
        for (NSString *httpHeaderField in globalCustomHeaderFieldValueDictionary.allKeys) {
            NSString *value = globalCustomHeaderFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    //分别设置子类Header
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

- (NSURLSessionDownloadTask *)downloadTaskWithBaseRequest:(SYNetworkBaseRequest*)baseRequest DownloadPath:(NSString *)downloadPath
                                        requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                                URLString:(NSString *)URLString
                                               parameters:(id)parameters
                                                 progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                                    error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:parameters error:error];
    
    NSString *downloadTargetPath;
    BOOL isDirectory;
    if(![[NSFileManager defaultManager] fileExistsAtPath:downloadPath isDirectory:&isDirectory]) {
        isDirectory = NO;
    }
    // If targetPath is a directory, use the file name we got from the urlRequest.
    // Make sure downloadTargetPath is always a file, not directory.
    if (isDirectory) {
        NSString *fileName = [urlRequest.URL lastPathComponent];
        downloadTargetPath = [NSString pathWithComponents:@[downloadPath, fileName]];
    } else {
        downloadTargetPath = downloadPath;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadTargetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:downloadTargetPath error:nil];
    }
    
    BOOL resumeDataFileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path];
    NSData *data = [NSData dataWithContentsOfURL:[self incompleteDownloadTempPathForDownloadPath:downloadPath]];
    //检验数据是否完整
    BOOL resumeDataIsValid = [SYNetworkUtils validateResumeData:data];
    
    BOOL canBeResumed = resumeDataFileExists && resumeDataIsValid;
    BOOL resumeSucceeded = NO;
    __block NSURLSessionDownloadTask *downloadTask = nil;
    // Try to resume with resumeData.
    // Even though we try to validate the resumeData, this may still fail and raise excecption.
    if (canBeResumed && baseRequest.isResumable) {
        @try {
            downloadTask = [_sessionManager downloadTaskWithResumeData:data progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                baseRequest.error = error;
                if (error && error.code != -999) {
                    //无法断点下载
                    if ([[NSFileManager defaultManager]fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path]) {
                        [[NSFileManager defaultManager]removeItemAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path error:nil];
                    }
                    
                }
                [self handleRequestResult:downloadTask responseObject:filePath error:error];
            }];
            resumeSucceeded = YES;
        } @catch (NSException *exception) {
            resumeSucceeded = NO;
        }
    }
    if (!resumeSucceeded) {
        if ([[NSFileManager defaultManager]fileExistsAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path]) {
            [[NSFileManager defaultManager]removeItemAtPath:[self incompleteDownloadTempPathForDownloadPath:downloadPath].path error:nil];
        }
        downloadTask = [_sessionManager downloadTaskWithRequest:urlRequest progress:downloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:downloadTargetPath isDirectory:NO];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            [self handleRequestResult:downloadTask responseObject:filePath error:error];
        }];
    }
    return downloadTask;
}

- (NSURLSessionDataTask *)dataTaskWithBaseRequest:(SYNetworkBaseRequest*)baseRequest HTTPMethod:(NSString *)method
                                requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                        URLString:(NSString *)URLString
                                       parameters:(id)parameters
                                            error:(NSError * _Nullable __autoreleasing *)error {
    return [self dataTaskWithBaseRequest:baseRequest HTTPMethod:method requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}

- (NSURLSessionDataTask *)dataTaskWithBaseRequest:(SYNetworkBaseRequest*)baseRequest HTTPMethod:(NSString *)method
                                requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                        URLString:(NSString *)URLString
                                       parameters:(id)parameters
                        constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                            error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if (baseRequest.uploadProgressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                baseRequest.uploadProgressBlock(uploadProgress);
            });
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        if (baseRequest.downloadProgressBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                baseRequest.downloadProgressBlock(downloadProgress);
            });
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleRequestResult:dataTask responseObject:responseObject error:error];
    }];
    
    return dataTask;
}


- (void)requestDidSucceedWithRequest:(SYNetworkBaseRequest *)request {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFinished:)]) {
            [request.delegate requestFinished:request];
        }
        
        if (request.successBlock) {
            request.successBlock(request);
        }
        
    });
}

- (void)requestDidFailWithRequest:(SYNetworkBaseRequest *)request error:(NSError *)error {
    request.error = error;
    
    //保存未下载的文件
    NSData *incompleteDownloadData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    if (incompleteDownloadData && request) {
        [incompleteDownloadData writeToURL:[self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath] atomically:YES];
    }
    
    //获取Request下载到本地的不完整文件删除
    if ([request.responseObject isKindOfClass:[NSURL class]]) {
        NSURL *url = request.responseObject;
        if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
            request.responseData = [NSData dataWithContentsOfURL:url];
            
            [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
        }
        request.responseObject = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(requestFailed:)]) {
            [request.delegate requestFailed:request];
        }
        
        if (request.failureBlock) {
            request.failureBlock(request);
        }
    });
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    
    //取出Request
    SYNetworkBaseRequest *request = [[SYNetworkRequestPool sharedPool]requestWithTaskID:[NSString stringWithFormat:@"%ld",task.taskIdentifier]];
    NSError * __autoreleasing serializationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = NO;
    
    request.responseObject = responseObject;
    if ([request.responseObject isKindOfClass:[NSData class]]) {
        request.responseData = responseObject;
        
        switch (request.responseSerializerType) {
            case SYResponseSerializerTypeHTTP:
                // Default serializer. Do nothing.
                break;
            case SYResponseSerializerTypeJSON:
                request.responseObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                request.responseJSONObject = request.responseObject;
                break;
            case SYResponseSerializerTypeXMLParser:
                request.responseObject = [self.xmlParserResponseSerialzier responseObjectForResponse:task.response data:request.responseData error:&serializationError];
                break;
        }
    }
    if (error) {
        succeed = NO;
        requestError = error;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
    } else {
        succeed = YES;
        requestError = nil;
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [request clearCompletionBlock];
        [[SYNetworkRequestPool sharedPool]removeRequest:request];
    });
}

- (void)cancelRequest:(SYNetworkBaseRequest *)request{
    NSParameterAssert(request != nil);
    if (request.requestType == SYRequestTypeDownload) {
        NSURLSessionDownloadTask *requestTask = (NSURLSessionDownloadTask *)request.requestTask;
        [requestTask cancelByProducingResumeData:^(NSData *resumeData) {
            if (requestTask.error == nil || requestTask.error.code == -999) {
                NSURL *localUrl = [self incompleteDownloadTempPathForDownloadPath:request.resumableDownloadPath];
                [resumeData writeToURL:localUrl atomically:YES];
            }
            
        }];
    } else {
        [request.requestTask cancel];
    }
    [request clearCompletionBlock];
    [[SYNetworkRequestPool sharedPool]removeRequest:request];
}

- (void)cancelAllRequests{
    [[SYNetworkRequestPool sharedPool]removeAllRequest];
}

#pragma mark - Resumable Download

- (NSString *)incompleteDownloadTempCacheFolder {
    NSFileManager *fileManager = [NSFileManager new];
    static NSString *cacheFolder;
    
    //在Temp下新建一个 Incomplete 文件夹
    if (!cacheFolder) {
        NSString *cacheDir = NSTemporaryDirectory();
        cacheFolder = [cacheDir stringByAppendingPathComponent:@"Incomplete"];
    }
    
    NSError *error = nil;
    if(![fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error]) {
        cacheFolder = nil;
    }
    return cacheFolder;
}

- (NSURL *)incompleteDownloadTempPathForDownloadPath:(NSString *)downloadPath {
    NSString *tempPath = nil;
    //通过下载Path来做MD5运算
    NSString *md5URLString = @"";
    if (TARGET_IPHONE_SIMULATOR) {
        //因为模拟器每次启动沙盒路径不一样，所以模拟器只需要读取文件名最后做MD5即可
        md5URLString = [SYNetworkUtils md5StringFromString:downloadPath.lastPathComponent];
    }else{
        md5URLString = [SYNetworkUtils md5StringFromString:downloadPath];
    }
    
    tempPath = [[self incompleteDownloadTempCacheFolder] stringByAppendingPathComponent:md5URLString];
    return [NSURL fileURLWithPath:tempPath];
}

#pragma mark - Getter
- (AFJSONResponseSerializer *)jsonResponseSerializer {
    if (!_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier {
    if (!_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
        _xmlParserResponseSerialzier.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
    }
    return _xmlParserResponseSerialzier;
}



@end
