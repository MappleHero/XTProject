//
//  XTNetworkCacheManager.h
//  XTrain
//
//  Created by Ben on 15/1/9.
//  Copyright (c) 2015年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XTNetworkRequest;

@interface XTNetworkCacheManager : NSObject


/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetworkCacheManager *)defaultManager;

/**
 *  缓存请求的数据
 *
 *  @param data    待缓存的数据
 *  @param request 请求
 */
- (void)cacheData:(id)data forRequest:(XTNetworkRequest *)request;

/**
 *  获取请求的缓存
 *
 *  @param request 请求
 *
 *  @return 缓存数据
 */
- (id)cachedDataWithRequest:(XTNetworkRequest *)request;

@end
