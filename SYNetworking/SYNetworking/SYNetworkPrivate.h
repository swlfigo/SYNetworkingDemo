//
//  SYNetworkPrivate.h
//  SYNetworking
//
//  Created by Sylar on 2019/5/5.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetworkRequest.h"
#import "SYNetworkBaseRequest.h"
#import "SYNetworkManager.h"
#import "SYNetworkConfig.h"
@interface SYNetworkBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
@property (nonatomic, strong, readwrite, nullable) NSData *responseData;
@property (nonatomic, strong, readwrite, nullable) id responseJSONObject;
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSString *responseString;
@property (nonatomic, strong, readwrite, nullable) NSError *error;

@end

@interface SYNetworkUtils : NSObject

+ (NSString *)md5StringFromString:(NSString *)string;

+ (BOOL)validateResumeData:(NSData *)data;

@end
