//
//  XTNetwork.h
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTNetworkRequest.h"
#import "XTNetworkResponse.h"

@interface XTNetwork : NSObject

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetwork *)defaultManager;

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
