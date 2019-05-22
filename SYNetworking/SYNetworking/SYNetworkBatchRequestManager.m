//
//  SYNetworkBatchRequestManager.m
//  SYNetworking
//
//  Created by Sylar on 2019/5/16.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "SYNetworkBatchRequestManager.h"
#import "SYNetworkBaseRequest.h"
#import <pthread/pthread.h>
@interface SYNetworkBatchRequestManager ()

@property (strong, nonatomic) NSMutableArray<SYNetworkBatchRequest *> *requestArray;

@end

@implementation SYNetworkBatchRequestManager{
    pthread_mutex_t _lock;
}
+ (SYNetworkBatchRequestManager *)sharedManager{
    static SYNetworkBatchRequestManager *sharedManager = NULL;
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
        //lock
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)addBatchRequest:(SYNetworkBatchRequest *)request{
    SYNetworkLock();
    [_requestArray addObject:request];
    SYNetworkUnLock();
}

- (void)removeBatchRequest:(SYNetworkBatchRequest *)request{
    SYNetworkLock();
    [_requestArray removeObject:request];
    SYNetworkUnLock();
}


@end
