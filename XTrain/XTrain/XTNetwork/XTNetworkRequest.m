//
//  XTNetworkRequest.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkRequest.h"
#import <AFNetworking/AFHTTPRequestOperation.h>
#import "XTNetworkEngine.h"
#import "XTEncodeUtil.h"
#import "NSString+Useful.h"
#import "XTNetworkResponse.h"

NSString *const XTRequestErrorDomain = @"com.xt.REQUESTERROR";

@implementation XTNetworkRequest

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p>:{requestID:%ld,\npath:%@,\nparams:%@,\n}",
            NSStringFromClass([self class]),
            self,
            (long)self.requestID,
            [self path],
            [self params]];
}

- (id)init
{
    if (self = [super init])
    {
        _responseClassName = @"XTNetworkResponse";
    }
    return self;
}

#pragma mark - action

- (void)start
{
    [[XTNetworkEngine defaultEngine] addRequest:self];
}

- (void)startWithCallback:(XTHTTPRequestCallback)callback
{
    self.callback = callback;
    [self start];
}

- (void)stop
{
    self.callback = nil;
    [[XTNetworkEngine defaultEngine] removeRequest:self];
}

#pragma mark - config

- (NSString *)baseURLString
{
    // Subclass override
    return nil;
}

- (NSString *)path
{
    // Subclass override
    return nil;
}

- (NSDictionary *)headers
{
    // Subclass override
    return nil;
}

- (NSDictionary *)params
{
    // Subclass override
    return nil;
}

- (NSString *)requestURLString
{
    // Subclass override
    return nil;
}

- (NSTimeInterval )cacheInterval
{
    // Subclass override
    return 0.0f;
}

- (NSString *)cacheFileName
{
    // TODO:Validate base url, path ...
    NSMutableString *fileName = [NSMutableString string];
    [fileName appendString:[self path]];
    
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

#pragma mark - Validate request

- (BOOL)validateWithError:(NSError **)error
{
    XTRequestErrorCode errorCode = 0;
    NSString *errorInfo = nil;
    if ([self baseURLString].length == 0)
    {
        errorCode = XTRequestErrorBaseURL;
        errorInfo = [NSString stringWithFormat:@"Request {%@}, [baseURLString] is INVALID", self];
    }
    
    if ([self path].length == 0)
    {
        errorCode = XTRequestErrorPath;
        errorInfo = [NSString stringWithFormat:@"Request {%@}, [path] is INVALID", self];
    }
    
    Class responseClass = NSClassFromString(self.responseClassName);
    if (![responseClass isSubclassOfClass:[XTNetworkResponse class]])
    {
        errorCode = XTRequestErrorResponseClassName;
        errorInfo = [NSString stringWithFormat:@"Request {%@}, [responseClassName] is INVALID", self];
    }
    
    if (errorCode != 0)
    {
        *error = [NSError errorWithDomain:XTRequestErrorDomain
                                     code:errorCode
                                 userInfo:@{NSLocalizedFailureReasonErrorKey:errorInfo}];
        return NO;
    }

    return YES;
}

@end
