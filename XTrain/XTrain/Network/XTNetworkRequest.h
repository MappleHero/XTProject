//
//  XTNetworkRequest.h
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const XTRequestErrorDomain;

@class XTNetworkResponse;

#define ONE_DAY 60*60*24

typedef NSInteger XTRequestID;

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
typedef void(^XTHTTPRequestCallback)(XTNetworkResponse *response);

@interface XTNetworkRequest : NSObject

/**
 *  请求方式
 */
@property (nonatomic, assign) XTHTTPMethodType methodType;
/**
 *  缓存策略
 */
@property (nonatomic, assign) XTHTTPCacheStrategy cacheStrategy;
/**
 *  响应回调
 */
@property (nonatomic, copy) XTHTTPRequestCallback callback;
/**
 *  请求响应的response类名，必须是XTNetworkResponse的子类
 */
@property (nonatomic, copy) NSString *responseClassName;
/**
 *  请求ID
 */
@property (nonatomic, assign) XTRequestID requestID;

#pragma mark - action

/**
 *  启动
 */
- (void)start;

/**
 *  启动
 *
 *  @param callback 响应回调
 */
- (void)startWithCallback:(XTHTTPRequestCallback)callback;

/**
 *  停止
 */
- (void)stop;

#pragma mark - config

/**
 *  获取服务器地址，子类覆写
 *
 *  @return 服务器地址
 */
- (NSString *)baseURLString;

/**
 *  获取请求路径，子类覆写
 *
 *  @return 请求路径
 */
- (NSString *)path;

/**
 *  获取请求头域，子类覆写
 *
 *  @return 请求头域
 */
- (NSDictionary *)headers;

/**
 *  获取请求参数，子类覆写
 *
 *  @return 请求参数
 */
- (NSDictionary *)params;

/**
 *  获取缓存时长，子类覆写
 *
 *  @return 缓存时长
 */
- (NSTimeInterval )cacheInterval;

/**
 *  请求的url，默认为nil，使用默认的方式拼装params构造url，子类覆写则使用子类返回的url
 *
 *  @return 请求url字符串
 */
- (NSString *)requestURLString;

/**
 *  获取缓存文件名
 *
 *  @return 缓存文件名
 */
- (NSString *)cacheFileName;

@end
