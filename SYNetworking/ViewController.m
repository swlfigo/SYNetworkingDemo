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
    
    SYNetworkRequest *downloadReq = [[SYNetworkRequest alloc]init];
    
    NSString *cacheDir = NSHomeDirectory();
    NSString * cacheFolder = [[cacheDir stringByAppendingPathComponent:@"Incomplete111"]stringByAppendingPathComponent:@"333"];
    downloadReq.resumableDownloadPath = cacheFolder;
    downloadReq.requestSerializerType = SYRequestSerializerTypeHTTP;
    [downloadReq sendRequest:@"https://images.unsplash.com/photo-1556724600-78e84788fca5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80" success:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    } failure:^(__kindof SYNetworkBaseRequest *request) {
        NSLog(@"");
    }];
}


@end
