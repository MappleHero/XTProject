//
//  TNServerURLConfig.m
//  XTrain
//
//  Created by Ben on 14/11/13.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "TNServerURLConfig.h"

NSString *const XTNetworkConfigUrlChanged = @"TNServerUrlChanged";

@implementation TNServerURLConfig

static TNServerURLConfig *_defaultConfig = nil;

+ (TNServerURLConfig *)defaultConfig
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
    _HTTPURLString = dictionary[@"HTTP"];
    _dynamicHTTPURLString = dictionary[@"DynamicHTTP"];
    _HTTPSURLString = dictionary[@"HTTPS"];
    _SSOURLString = dictionary[@"SSO"];
    _chatURLString = dictionary[@"CHAT"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XTNetworkConfigUrlChanged
                                                        object:nil];
}
@end
