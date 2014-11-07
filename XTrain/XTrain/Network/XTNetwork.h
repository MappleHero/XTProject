//
//  XTNetwork.h
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTNetworkRequest.h"

@interface XTNetwork : NSObject

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetwork *)defaultManager;

/**
 *  发送请求
 *
 *  @param request 请求对象
 */
- (void)sendRequest:(XTNetworkRequest *)request;

@end
