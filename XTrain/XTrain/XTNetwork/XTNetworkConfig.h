//
//  XTNetworkConfig.h
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTNetworkConfig : NSObject

@property (nonatomic, copy, readonly) NSString *HTTPCachePath;

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetworkConfig *)defaultConfig;

/**
 *  配置HTTP缓存路径
 *
 *  @param cachePath 缓存路径，默认父目录为Documents，传入目录即可，如"HTTPCache"，
 *  通过HTTPCachePath可获取到全路径
 *
 *  @return 是否成功
 */
- (BOOL)configHTTPCachePath:(NSString *)cachePath;

@end
