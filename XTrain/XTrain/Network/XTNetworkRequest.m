//
//  XTNetworkRequest.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkRequest.h"

NSString *const XTRequestErrorDomain = @"com.xt.REQUESTERROR";

@implementation XTNetworkRequest

- (NSString *)description
{
    return [NSString stringWithFormat:@"XTNetworkRequest:path[%@]\n,params:[%@]",
            self.path,self.params];
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

@end
