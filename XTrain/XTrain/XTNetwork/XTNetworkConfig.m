//
//  XTNetworkConfig.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkConfig.h"
#import "XTLog.h"
#import "XTUtil.h"

@interface XTNetworkConfig ()


@end

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

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self defaultConfig];
}

- (BOOL)configHTTPCachePath:(NSString *)cachePath
{
    NSString *fullPath = [[XTUtil appDocPath] stringByAppendingPathComponent:cachePath];
    if (self.HTTPCachePath
        && ![self.HTTPCachePath isEqualToString:fullPath])
    {
        XTLogError(@"XTNetworkConfig", @"HTTP cache path has already be configed!");
        return NO;
    }
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory])
    {
//        if (!isDirectory)
//        {
//            XTLogError(@"XTNetworkConfig", @"Input param{%@}, is NOT a valid directory!", cachePath);
//            return NO;
//        }
        [[NSFileManager defaultManager] createDirectoryAtPath:fullPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    
    _HTTPCachePath = fullPath;
    return YES;
}

@end
