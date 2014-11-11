//
//  XTUtil.m
//  XTrain
//
//  Created by Ben on 14/11/11.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTUtil.h"

@implementation XTUtil

+ (NSString *)appDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths firstObject];
}

@end
