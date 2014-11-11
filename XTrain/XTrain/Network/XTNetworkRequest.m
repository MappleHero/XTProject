//
//  XTNetworkRequest.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkRequest.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "XTNetwork.h"
#import "XTEncodeUtil.h"
#import "NSString+Useful.h"

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

- (void)start
{
    [[XTNetwork defaultManager] addRequest:self];
}

- (void)stop
{
    self.callback = nil;
    [[XTNetwork defaultManager] removeRequest:self];
}

- (NSString *)cacheFileName
{
    NSMutableString *fileName = [NSMutableString string];
    [fileName appendString:self.path];
    
    if ([self.params count] > 0)
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.params
                                                           options:0
                                                             error:nil];
        if (jsonData)
        {
            [fileName appendString:[XTEncodeUtil MD5Hash:jsonData]];
        }
    }
    
    return [fileName md5String];
}

@end
