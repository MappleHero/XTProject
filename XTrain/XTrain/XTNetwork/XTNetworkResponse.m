//
//  XTNetworkResponse.m
//  XTrain
//
//  Created by Ben on 14/11/10.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkResponse.h"

NSString *const XTResponseErrorDomain = @"com.xt.RESPONSEERROR";

@implementation XTNetworkResponse

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p>:{success:%d,\nHTTPStatusCode:%ld,\nfromCache:%d,\nresponseString:%@,\nerror:%@,\n}",
            NSStringFromClass([self class]),
            self,
            self.success,
            (long)self.HTTPStatusCode,
            self.fromCache,
            self.responseString,
            self.error];
}

- (void)handleBusiness
{
    // Subclass override
}

@end
