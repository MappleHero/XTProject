//
//  XTNetworkCommon.h
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#define NET_CONFIG_FILE_NAME @"NetworkConfig-R"

FOUNDATION_EXPORT NSString *const XTRequestErrorDomain;
FOUNDATION_EXPORT NSString *const XTResponseErrorDomain;

typedef NS_ENUM(NSInteger, XTHTTPRequestType)
{
    XTHTTPRequestTypeHTTP = 0, // HTTP请求
    XTHTTPRequestTypeDynamicHTTP, // Dynamic HTTP请求
    XTHTTPRequestTypeHTTPS, // HTTPS请求
    XTHTTPRequestTypeCHAT // CHAT请求

};

typedef NS_ENUM(NSInteger, XTHTTPCacheStrategy)
{
    XTHTTPCacheStrategyCacheAndNet = 0, // 先返回缓存，再返回
    XTHTTPCacheStrategyCacheOnly, // 只返回缓存
    XTHTTPCacheStrategyNetOnly // 只返回网络数据
};

typedef NS_ENUM(NSInteger, XTHTTPMethodType)
{
    XTHTTPMethodGET = 0, // GET
    XTHTTPMethodPOST, // POST
    XTHTTPMethodDELETE // DELETE
};

/**
 *  请求回调信息
 */
typedef void(^XTHTTPRequestCallback)(id responseObject, NSError *error);