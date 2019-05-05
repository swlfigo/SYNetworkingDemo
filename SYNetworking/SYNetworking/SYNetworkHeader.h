//
//  SYNetworkHeader.h
//  SYNetworking
//
//  Created by Sylar on 2019/4/29.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#ifndef SYNetworkHeader_h
#define SYNetworkHeader_h
#import <AFNetworking/AFNetworking.h>

#endif /* SYNetworkHeader_h */

#define SYNetworkLock() pthread_mutex_lock(&_lock)
#define SYNetworkUnLock() pthread_mutex_unlock(&_lock)
@class SYNetworkBaseRequest;
///  Request serializer type.
typedef NS_ENUM(NSInteger, SYRequestSerializerType) {
    SYRequestSerializerTypeHTTP = 0,
    SYRequestSerializerTypeJSON,    //Default
};

///  Response serializer type, which determines response serialization process and
///  the type of `responseObject`.
typedef NS_ENUM(NSInteger, SYResponseSerializerType) {
    /// NSData type
    SYResponseSerializerTypeHTTP,   //Default
    /// JSON object type
    SYResponseSerializerTypeJSON,
    /// NSXMLParser type
    SYResponseSerializerTypeXMLParser,
};



typedef void(^SYCompletionBlock)(__kindof  SYNetworkBaseRequest *request);
typedef void(^SYProgressBlock)(NSProgress * _Nonnull progress);


//Post Form Data Block
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

typedef NSDictionary* (^SYRequestCustomHeaderBlock)(void);

/**
 *  HTTP Request method
 */
typedef NS_ENUM(NSInteger, SYRequestMethod) {
    
    SYRequestMethodGET ,
    SYRequestMethodPOST,
    SYRequestMethodHEAD,
    SYRequestMethodPUT,
    SYRequestMethodDELETE,
    SYRequestMethodPATCH
    
};
