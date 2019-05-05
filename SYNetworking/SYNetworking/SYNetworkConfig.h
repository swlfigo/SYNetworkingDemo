//
//  SYNetworkConfig.h
//  SYNetworking
//
//  Created by Sylar on 2019/4/30.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SYNetworkConfig : NSObject

// Custom headers , Default nil
@property (nonatomic, readonly, strong) NSDictionary * _Nullable customHeaders;

// Default parameters, default is nil
@property (nonatomic, readonly, strong) NSDictionary * _Nullable defaultParameters;

// Request timeout seconds, default is 20 (second)
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

/**
 *  can not use new method
 */
+ (instancetype _Nullable)new NS_UNAVAILABLE;


+ (SYNetworkConfig *_Nullable)sharedConfig;


- (void)addCustomHeader:(NSDictionary *_Nonnull)header;

- (void)addCustomParameters:(NSDictionary *_Nonnull)parameters;

@end


