//
//  XTNetworkEngine.h
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XTNetworkRequest;

@interface XTNetworkEngine : NSObject

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetworkEngine *)defaultEngine;

/**
 *  注册一个HTTP客户端
 *
 *  @param baseURLString 服务器的url
 *
 *  @return 是否成功
 */
- (BOOL)registerClientWithBaseURLString:(NSString *)baseURLString;

/**
 *  注销一个HTTP客户端
 *
 *  @param baseURLString 服务器的url
 *
 *  @return 是否成功
 */
- (BOOL)deregisterClientWithBaseURLString:(NSString *)baseURLString;

/**
 *  注销所有HTTP客户端
 */
- (void)deregisterAllClients;

/**
 *  添加请求
 *
 *  @param request 请求对象
 */
- (void)addRequest:(XTNetworkRequest *)request;

/**
 *  取消请求
 *
 *  @param request 请求对象
 */
- (void)removeRequest:(XTNetworkRequest *)request;

@end
