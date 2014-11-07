//
//  XTVersion.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTVersion.h"

@implementation XTSplash

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

@end

@implementation XTVersion

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

+ (NSValueTransformer *)splashJSONTransformer
{
    return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[XTSplash class]];
}

@end
