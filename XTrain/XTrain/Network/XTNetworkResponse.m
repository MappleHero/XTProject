//
//  XTNetworkResponse.m
//  XTrain
//
//  Created by Ben on 14/11/10.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkResponse.h"

@implementation XTNetworkResponse

- (NSString *)description
{
    return [NSString stringWithFormat:@"success:[%d] HTTPStatusCode[%ld] fromCache[%d] JSONString[%@] error[%@]", self.success,(long)self.HTTPStatusCode,
            self.fromCache, self.JSONString, self.error];
}

@end
