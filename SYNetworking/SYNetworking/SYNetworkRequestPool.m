//
//  SYNetworkRequestPool.m
//  SYNetworking
//
//  Created by Sylar on 2019/4/30.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkRequestPool.h"
#import "SYNetworkBaseRequest.h"
#import <pthread/pthread.h>



@interface SYNetworkRequestPool ()
@property(nonatomic,strong)NSMutableDictionary *currentTasksDic;
@end

@implementation SYNetworkRequestPool{
    pthread_mutex_t _lock;
}

+ (SYNetworkRequestPool *)sharedPool {
    
    static SYNetworkRequestPool *sharedPool = NULL;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedPool = [[super allocWithZone:NULL] init] ;
    });
    return sharedPool;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        //lock
        pthread_mutex_init(&_lock, NULL);
        
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [SYNetworkRequestPool sharedPool] ;
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [SYNetworkRequestPool sharedPool] ;
}


#pragma mark - Handle Request Pool

- (SYCurrentAllRequests *)currentAllRequests{
    if (!_currentTasksDic) {
        _currentTasksDic = [[NSMutableDictionary alloc]init];
    }
    return _currentTasksDic;
}

- (SYNetworkBaseRequest *)requestWithTaskID:(NSString *)taskID{
    if (!taskID) {
        return nil;
    }
    SYNetworkLock();
    SYNetworkBaseRequest *request = [self.currentAllRequests valueForKey:taskID];
    SYNetworkUnLock();
    return request;
}


- (void)addRequest:(SYNetworkBaseRequest *)request{
    
    SYNetworkLock();
    [self.currentAllRequests setObject:request forKey:[NSString stringWithFormat:@"%ld",request.requestTask.taskIdentifier]];
    SYNetworkUnLock();
}



- (void)removeRequest:(SYNetworkBaseRequest *)request{
    
    SYNetworkLock();
    [self.currentAllRequests removeObjectForKey:[NSString stringWithFormat:@"%ld",request.requestTask.taskIdentifier]];
    SYNetworkUnLock();
    
}


- (void)removeAllRequest{
    SYNetworkLock();
    NSArray *allKeys = [self.currentTasksDic allKeys];
    SYNetworkUnLock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            SYNetworkLock();
            SYNetworkBaseRequest *request = _currentTasksDic[key];
            SYNetworkUnLock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}


- (BOOL)remainingCurrentRequests{
    
    NSArray *keys = [self.currentAllRequests  allKeys];
    if ([keys count]>0) {
        return YES;
    }
    return NO;
}


- (NSInteger)currentRequestCount{
    
    if(![self remainingCurrentRequests]){
        return 0;
    }
    NSArray *keys = [self.currentAllRequests allKeys];
    return [keys count];
    
}

@end
