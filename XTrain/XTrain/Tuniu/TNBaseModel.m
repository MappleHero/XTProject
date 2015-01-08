//
//  TNBaseModel.m
//  XTrain
//
//  Created by Ben on 15/1/8.
//  Copyright (c) 2015年 XTeam. All rights reserved.
//

#import "TNBaseModel.h"

@implementation TNBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSNull class]])
    {
        return;
    }
    [super setValue:value forKey:key];
}

@end
