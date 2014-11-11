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
 *  是否是缓存
 */
@property (nonatomic, assign) BOOL fromCache;
/**
 *  JSON串
 */
@property (nonatomic, strong) NSString *JSONString;
/**
 *  JSON串序列化的Model
 */
@property (nonatomic, strong) id responseModel;
/**
 *  错误信息
 */
@property (nonatomic, strong) NSError *error;

@end
