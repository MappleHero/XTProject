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
 *  请求类型
 */
@property (nonatomic, assign) XTHTTPRequestType requestType;
/**
 *  请求路径
 */
@property (nonatomic, copy) NSString *path;
/**
 *  请求方式
 */
@property (nonatomic, assign) XTHTTPMethodType methodType;
/**
 *  请求参数
 */
@property (nonatomic, strong) NSDictionary *params;
/**
 *  请求头域
 */
@property (nonatomic, strong) NSDictionary *headers;
/**
 *  缓存策略
 */
@property (nonatomic, assign) XTHTTPCacheStrategy cacheStrategy;
/**
 *  缓存时长
 */
@property (nonatomic, assign) NSTimeInterval cacheInterval;
/**
 *  返回数据的类，类必须从MTLModel继承，并且实现MTLJSONSerializing协议
 */
@property (nonatomic, copy) NSString *responseObjectClassName;
/**
 *  响应回调
 */
@property (nonatomic, copy) XTHTTPRequestCallback callback;
/**
 *  operation对象
 */
@property (nonatomic, strong) AFHTTPRequestOperation *operation;

/**
 *  启动
 */
- (void)start;

/**
 *  停止
 */
- (void)stop;

/**
 *  获取缓存文件名
 *
 *  @return 缓存文件名
 */
- (NSString *)cacheFileName;

@end
