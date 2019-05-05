# SYNetworkingDemo
AF封装网路库Demo


Inspire of `YTKNetwork`

# Base Usage:
```objective-c

//可简单配置简单请求
SYNetworkRequest *req = [[SYNetworkRequest alloc]init];
//设置返回数据解析格式
//默认返回数据格式解析为 JSON 格式
req.responseSerializerType = SYResponseSerializerTypeHTTP;
[req sendRequest:@"https://www.baidu.com" success:^(__kindof SYNetworkBaseRequest *request) {
  NSLog(@"");
} failure:^(__kindof SYNetworkBaseRequest *request) {
  NSLog(@"");
}];

```

如果需要深度配置或独立出来的一个 `Request`, 需要继承 `SYNetworkRequest`, 在类里面配置网址等参数
