//
//  XTNetworkConfig.h
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTNetworkConfig : NSObject

@property (nonatomic, strong) NSString *HTTPCachePath;

/**
 *  单例
 *
 *  @return 单例对象
 */
+ (XTNetworkConfig *)defaultConfig;

@end
