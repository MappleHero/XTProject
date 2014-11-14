//
//  TNVersion.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "TNVersion.h"

#pragma mark - Model

@implementation TNSplash

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

@end

@implementation TNVersion

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSValueTransformer *)splashJSONTransformer
{
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TNSplash class]];
}

@end

#pragma mark - Request

@implementation TNVersionRequest

- (NSString *)path
{
    return @"checkUpgradeV382";
}

- (NSDictionary *)params
{
    return @{@"clientType": @(10),
             @"currentVersion":@"5.0,0",
             @"splashId":@(0),
             @"width":@(640),
             @"height":@(936),
             @"r":@([[NSDate date] timeIntervalSince1970]),
             @"partner":@14588,
             @"deviceType":@0,
             @"version":@"5.0.0"};
}

- (TNRequestServerType)requestServerType
{
    return TNRequestServerTypeDynamicHTTP;
}

- (XTHTTPCacheStrategy)cacheStrategy
{
    return XTHTTPCacheStrategyNetOnly;
}

@end

#pragma mark - Response

@implementation TNVersionResponse

- (NSString *)modelClassName
{
    return NSStringFromClass([TNVersion class]);
}

@end