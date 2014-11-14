//
//  XTNetworkConfig.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkConfig.h"

@implementation XTNetworkConfig

static XTNetworkConfig *_defaultConfig = nil;

+ (XTNetworkConfig *)defaultConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfig = [[super allocWithZone:NULL] init];
    });
    return _defaultConfig;
}

- (void)setHTTPCachePath:(NSString *)HTTPCachePath
{
    _HTTPCachePath = HTTPCachePath;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:HTTPCachePath isDirectory:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:HTTPCachePath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
}

@end
