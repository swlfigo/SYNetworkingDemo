//
//  SYNetworkConfig.m
//  SYNetworking
//
//  Created by Sylar on 2019/4/30.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkConfig.h"

@interface SYNetworkConfig ()
@property (nonatomic, readwrite, strong) NSDictionary *customHeaders;
@property (nonatomic, readwrite, strong) NSDictionary *defaultParameters;
@end

@implementation SYNetworkConfig


+ (SYNetworkConfig *)sharedConfig {
    
    static SYNetworkConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super allocWithZone:NULL] init] ;
        sharedInstance.timeoutSeconds = 20;
    });
    return sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [SYNetworkConfig sharedConfig] ;
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [SYNetworkConfig sharedConfig] ;
}

- (void)addCustomHeader:(NSDictionary *)header{
    if (![header isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([[header allKeys] count] == 0) {
        return;
    }
    if (!_customHeaders) {
        _customHeaders = header;
        return;
    }
    //add custom header
    NSMutableDictionary *headers_m = [_customHeaders mutableCopy];
    [header enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        [headers_m setObject:value forKey:key];
    }];
    
    _customHeaders = [headers_m copy];
}


- (void)addCustomParameters:(NSDictionary *)parameters{
    if (![parameters isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([[parameters allKeys] count ] == 0) {
        return;
    }
    if (!_defaultParameters) {
        _defaultParameters = parameters;
    }
    //add custom parameters
    NSMutableDictionary *parameters_m = [_defaultParameters mutableCopy];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        [parameters_m setObject:value forKey:key];
    }];
    
    _defaultParameters = [parameters_m copy];
}


@end
