//
//  ViewController.m
//  SYNetworking
//
//  Created by Sylar on 2019/4/29.
//  Copyright © 2019年 iSylar. All rights reserved.
//

#import "ViewController.h"
#import "SYNetworking.h"
#import "SYNetworkRequest.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SYNetworkRequest *req = [[SYNetworkRequest alloc]init];
    req.responseSerializerType = SYResponseSerializerTypeHTTP;
    [req sendRequest:@"https://www.baidu.com" success:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    } failure:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    }];
    
    __block SYNetworkRequest *downloadReq = [[SYNetworkRequest alloc]init];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePathDes = [path stringByAppendingPathComponent:@"1111.jpg"];
    downloadReq.resumableDownloadPath = filePathDes;
    downloadReq.requestSerializerType = SYRequestSerializerTypeHTTP;
    downloadReq.resumableDownloadProgressBlock = ^(NSProgress * _Nonnull progress) {
      NSLog(@"%f \n\n",progress.completedUnitCount / (progress.totalUnitCount / 1.0));
    };
    [downloadReq sendRequest:@"https://images.unsplash.com/photo-1556724600-78e84788fca5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80" success:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    } failure:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [downloadReq stop];
    });
    

    
}


@end
