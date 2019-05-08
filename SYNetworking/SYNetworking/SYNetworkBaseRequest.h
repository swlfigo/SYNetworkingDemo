//
//  SYNetworkBaseRequest.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/2.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetworkHeader.h"
@interface SYNetworkBaseRequest : NSObject


#pragma mark - SubClass Config

//请求网址配置,可通过子类重写
@property (nonatomic, readwrite, strong) NSString *requestURL;

//请求Param,可通过子类重写
@property (nonatomic, readwrite, strong) id requestArgument;

//HTTP request method. 可通过子类重写
@property (nonatomic, readwrite, assign) SYRequestMethod requestMethod;

//Post Form Block . 可通过子类重写
@property (nonatomic, readwrite, copy) AFConstructingBlock constructingBodyBlock;

//RequestSerializerType . 可通过子类重写
@property (nonatomic, readwrite, assign) SYRequestSerializerType requestSerializerType;

//ResponseSerializerType . 可通过子类重写
@property (nonatomic, readwrite, assign) SYResponseSerializerType responseSerializerType;


//Timeout Default SYNetworkConfig timeoutSeconds . 可通过子类重写;
@property (nonatomic, readwrite, assign) NSTimeInterval requestTimeoutInterval;

//下载路径,不设置默认为简单HTTP请求 . 可通过子类重写
@property (nonatomic, strong, nullable) NSString *resumableDownloadPath;

// 下载百分比Block.
@property (nonatomic, copy, nullable) AFURLSessionTaskProgressBlock resumableDownloadProgressBlock;

// 请求类型. 普通请求或下载请求 
- (SYRequestType)requestType;

#pragma mark - Request and Response Information


//是否允许使用蜂窝数据 Default YES
@property (nonatomic, readwrite, assign) BOOL allowsCellularAccess;

//Response Obj
@property (nonatomic, strong, readonly) NSData *responseData;
@property (nonatomic, strong, readonly) id responseJSONObject;
@property (nonatomic, strong, readonly) id responseObject;

///  This error can be either serialization error or network error. If nothing wrong happens
///  this value will be nil.
@property (nonatomic, strong, readonly, nullable) NSError *error;

//Request Header Dic
@property (nonatomic, readwrite, strong) NSDictionary<NSString *, NSString *>* requestHeaderFieldValueDictionary;

//Request Task
@property (nonatomic, readonly, strong) NSURLSessionTask *requestTask;

/// `requestTask.response`.
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;

///  The response status code 状态码.
@property (nonatomic, readonly) NSInteger responseStatusCode;

///  The response header fields.
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;


@property (nonatomic, readwrite, copy) SYCompletionBlock successBlock;

@property (nonatomic, readwrite, copy) SYCompletionBlock failureBlock;

@property (nonatomic, readwrite, copy) SYProgressBlock uploadProgressBlock;

@property (nonatomic, readwrite, copy) SYProgressBlock downloadProgressBlock;

#pragma mark - Request Configuartion

///  Nil out both success and failure callback blocks.
- (void)clearCompletionBlock;


#pragma mark - Request Action
//可手动配置完Request, 执行 Star 请求
///  Append self to request queue and start the request.
- (void)start;

///  Remove self from request queue and cancel the request.
- (void)stop;


@end

