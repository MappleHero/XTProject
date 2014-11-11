XTProjiect
==========
##网络
* `XTNetwork`HTTP请求底层能力处理类，封装了请求参数构造和响应数据的处理，将返回结果json串序列化成`MTLModel`的对象，处理请求的缓存控制逻辑，服务对象为业务处理类，某种情况下为了方便处理，UI也可直接调用
* `XTNetworkRequest`构造请求对象，封装请求参数，定义响应处理逻辑
* `XTNetworkConfig`网络配置类，存放一些网络请求的通用配置
* `XTNetworkCommon`网络框架的一些定义

####使用方法
**1. 初始化配置**
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
	// 加载URL配置
    [[XTNetworkConfig defaultConfig] loadConfig];
   
   // 配置缓存路径
    [XTNetworkConfig defaultConfig].HTTPCachePath = [[XTUtil appDocPath] stringByAppendingPathComponent:@"HTTPCache"];
    ...
}
```

**2. 发送请求**
```
XTNetworkRequest *request = [[XTNetworkRequest alloc] init];
request.path = @"Path";
request.params = @{...};
request.requestType = XTHTTPRequestTypeDynamicHTTP;
request.methodType = XTHTTPMethodGET;
request.responseObjectClassName = NSStringFromClass([MTLModel class]);
request.callback = ^(XTNetworkResponse *response){
    ...
};
[request start];
```
##日志
`XTLog`日志

`XTLog(level,Category,fmt...)`

* **level:**日志等级，取值为`XTL_VERBOSE_LVL` `XTL_DEBUG_LVL` `XTL_INFO_LVL` `XTL_WARN_LVL` `XTL_ERROR_LVL`
* **category:**模块名，例如@"XTNetwork"
* **fmt...:**日志内容
###源码片段
```
...
if (![self validateRequest:request error:&error])
{
		...
		XTLog(XTNETWORK_LOG_ERROR, @"Request:{%@} invalid!", request);
		
		...
}
```