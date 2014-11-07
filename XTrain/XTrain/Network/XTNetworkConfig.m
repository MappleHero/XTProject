//
//  XTNetworkConfig.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkConfig.h"
#import "XTNetworkCommon.h"

NSString *const XTNetworkConfigUrlChanged = @"XTNetworkConfigUrlChanged";

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

- (void)loadConfig
{
    NSString *file = [[NSBundle mainBundle] pathForResource:NET_CONFIG_FILE_NAME  ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:file];
    [self configURLWithDictonary:dictionary];
}

- (void)configURLWithDictonary:(NSDictionary *)dictionary
{
    _HTTPSUrlString = dictionary[@"HTTP"];
    _dynamicHTTPUrlString = dictionary[@"DynamicHTTP"];
    _HTTPSUrlString = dictionary[@"HTTPS"];
    _SSOUrlString = dictionary[@"SSO"];
    _chatUrlString = dictionary[@"CHAT"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XTNetworkConfigUrlChanged
                                                        object:nil];
}

@end
