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
    
    
}


@end
