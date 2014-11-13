//
//  XTNetworkResponse.h
//  XTrain
//
//  Created by Ben on 14/11/10.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTNetworkResponse : NSObject

/**
 *  请求是否成功
 */
@property (nonatomic, assign) BOOL success;
/**
 *  HTTP协议状态码
 */
@property (nonatomic, assign) NSInteger HTTPStatusCode;
/**
 *  响应数据
 */
@property (nonatomic, strong) NSData *responseData;
/**
 *  响应字符串
 */
@property (nonatomic, strong) NSString *responseString;
/**
 *  是否是缓存
 */
@property (nonatomic, assign) BOOL fromCache;
/**
 *  错误信息
 */
@property (nonatomic, strong) NSError *error;

/**
 *  处理业务，子类覆写该方法处理业务，比如序列化responseString为对象，处理业务错误码等
 */
- (void)handleBusiness;

@end
