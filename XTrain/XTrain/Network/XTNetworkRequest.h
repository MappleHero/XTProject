//
//  XTNetworkRequest.h
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTNetworkCommon.h"
#import "XTNetworkResponse.h"

@class AFHTTPRequestOperation;

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
 *  operation对象
 */
@property (nonatomic, strong) AFHTTPRequestOperation *operation;
/**
 *  请求响应的response类名，必须是XTNetworkResponse的子类
 */
@property (nonatomic, copy) NSString *responseClassName;

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
 *  获取服务器地址
 *
 *  @return 服务器地址
 */
- (NSString *)baseURLString;

/**
 *  获取请求路径
 *
 *  @return 请求路径
 */
- (NSString *)path;

/**
 *  获取请求头域
 *
 *  @return 请求头域
 */
- (NSDictionary *)headers;

/**
 *  获取请求参数
 *
 *  @return 请求参数
 */
- (NSDictionary *)params;

/**
 *  获取缓存时长
 *
 *  @return 缓存时长
 */
- (NSTimeInterval )cacheInterval;

/**
 *  获取缓存文件名
 *
 *  @return 缓存文件名
 */
- (NSString *)cacheFileName;

@end
