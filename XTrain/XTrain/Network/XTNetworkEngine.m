//
//  XTNetworkEngine.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetworkEngine.h"
#import <AFNetworking/AFNetworking.h>
#import "XTNetworkConfig.h"
#import "XTLog.h"
#import "XTNetworkRequest.h"
#import "XTNetworkResponse.h"

#define XTNETWORK_LOG_VERBOSE  XTL_VERBOSE_LVL,@"XTNetwork"
#define XTNETWORK_LOG_DEBUG  XTL_DEBUG_LVL,@"XTNetwork"
#define XTNETWORK_LOG_INFO  XTL_INFO_LVL,@"XTNetwork"
#define XTNETWORK_LOG_WARN  XTL_WARN_LVL,@"XTNetwork"
#define XTNETWORK_LOG_ERROR  XTL_ERROR_LVL,@"XTNetwork"

@interface XTNetworkEngine ()

@property (nonatomic, strong) NSMutableDictionary *managerDictionary;

@end

@implementation XTNetworkEngine

#pragma mark - Singletone

static XTNetworkEngine *_defaultEngine = nil;

+ (XTNetworkEngine *)defaultEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultEngine = [[super allocWithZone:NULL] init];
    });
    return _defaultEngine;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self defaultEngine];
}

#pragma mark - Init

- (id)init
{
    if (self = [super init])
    {
        _managerDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Request

- (BOOL)validateRequest:(XTNetworkRequest *)request error:(NSError **)error
{
    // TODO:Validate request
    return YES;
}

- (void)addRequest:(XTNetworkRequest *)request
{
    NSError *error = nil;
    XTLog(XTNETWORK_LOG_VERBOSE, @"Add request:{%@}", request);
    // Validate request
    if (![self validateRequest:request error:&error])
    {
        XTLog(XTNETWORK_LOG_ERROR, @"Request:{%@} invalid!", request);

        XTNetworkResponse *response = [self responseWithRequest:request];
        response.error = error;
        [response handleBusiness];
        dispatch_async(dispatch_get_main_queue(), ^{
            request.callback(response);
        });
        return;
    }
    
    // Return the cache
    if (request.cacheStrategy != XTHTTPCacheStrategyNetOnly)
    {
        NSString *cachedResponseString = [self cachedStringWithRequest:request];
        
        XTNetworkResponse *response = [self responseWithRequest:request];
        response.success = YES;
        response.responseString = cachedResponseString;
        // Maybe not right, cause I didn't cache the data ...
        response.responseData = [cachedResponseString dataUsingEncoding:NSUTF8StringEncoding];
        response.fromCache = YES;
        [response handleBusiness];
        dispatch_async(dispatch_get_main_queue(), ^{
            request.callback(response);
        });
        
    }
    
    if (request.cacheStrategy == XTHTTPCacheStrategyCacheOnly)
    {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self mangerWithBaseURL:request.baseURLString];
    NSString *methodString = nil;
    switch (request.methodType)
    {
        case XTHTTPMethodGET:
            methodString = @"GET";
            break;
        case XTHTTPMethodPOST:
            methodString = @"POST";
            break;
        case XTHTTPMethodDELETE:
            methodString = @"DELETE";
            break;
        default:
            break;
    }
    
    NSURLRequest *urlRequest = [manager.requestSerializer requestWithMethod:methodString
                                                                  URLString:[[NSURL URLWithString:request.path relativeToURL:manager.baseURL] absoluteString]
                                                                 parameters:request.params
                                                                      error:nil];

    AFHTTPRequestOperation *operation = [manager
                                         HTTPRequestOperationWithRequest:urlRequest
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             XTNetworkResponse *response = [self responseWithRequest:request];
                                             response.success = YES;
                                             response.HTTPStatusCode = operation.response.statusCode;
                                             response.responseString = operation.responseString;
                                             response.responseData = operation.responseData;
                                             response.error = nil;
                                             [response handleBusiness];
                                             if (request.callback)
                                             {
                                                 request.callback(response);
                                             }
                                             
                                             // cache
                                             if ([self requestShouldCache:request])
                                             {
                                                 [self cacheString:operation.responseString forRequest:request];
                                             }
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             XTNetworkResponse *response = [self responseWithRequest:request];
                                             response.success = NO;
                                             response.HTTPStatusCode = operation.response.statusCode;
                                             response.error = error;
                                             if (request.callback)
                                             {
                                                 request.callback(response);
                                             }
                                         }];
    request.operation = operation;
    [manager.operationQueue addOperation:operation];
}

- (void)removeRequest:(XTNetworkRequest *)request
{
    XTLog(XTNETWORK_LOG_VERBOSE, @"Remove request:{%@}", request);
    [request.operation cancel];
}

- (XTNetworkResponse *)responseWithRequest:(XTNetworkRequest *)request
{
    Class responseClass = NSClassFromString(request.responseClassName);
    if (![responseClass isSubclassOfClass:[XTNetworkResponse class]])
    {
        return nil;
    }
    XTNetworkResponse *response = [[responseClass alloc] init];
    return response;
}

#pragma mark - HTTP client

- (BOOL)registerClientWithBaseURLString:(NSString *)baseURLString
{
    // TODO:校验baseURLString
    
    if (self.managerDictionary[baseURLString])
    {
        return YES;
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.managerDictionary[baseURLString] = manager;
    
    return YES;
}

- (BOOL)deregisterClientWithBaseURLString:(NSString *)baseURLString
{
    // TODO:校验baseURLString
    
    AFHTTPRequestOperationManager *manger = self.managerDictionary[baseURLString];
    if (!manger)
    {
        return YES;
    }
    
    // TODO:停止manager的所有任务
    
    [self.managerDictionary removeObjectForKey:baseURLString];
    return YES;
}

- (void)deregisterAllClients
{
    for (NSString *baseURLString in [self.managerDictionary allKeys])
    {
        [self deregisterClientWithBaseURLString:baseURLString];
    }
}

- (AFHTTPRequestOperationManager *)mangerWithBaseURL:(NSString *)baseURLString
{
    return self.managerDictionary[baseURLString];
}

#pragma mark - Cache

- (BOOL)requestShouldCache:(XTNetworkRequest *)requset
{
    return [requset cacheInterval] > 0;
}

- (id)cachedStringWithRequest:(XTNetworkRequest *)request
{
    NSString *filePath = [[XTNetworkConfig defaultConfig].HTTPCachePath stringByAppendingPathComponent:[request cacheFileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil])
    {
        XTLog(XTNETWORK_LOG_WARN, @"Request:{%@}, cache NOT exist", request);
        return nil;
    }
    
    // Validate cache
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                             error:&attributesRetrievalError];
    if (!attributes)
    {
        XTLog(XTNETWORK_LOG_ERROR, @"Request:{%@}, failed to get file modification date");
        return nil;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    
    if (seconds > [request cacheInterval])
    {
        XTLog(XTNETWORK_LOG_ERROR, @"Request:{%@}, cache EXPIRED");
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)cacheString:(NSString *)responseString forRequest:(XTNetworkRequest *)request
{
    NSString *filePath = [[XTNetworkConfig defaultConfig].HTTPCachePath stringByAppendingPathComponent:[request cacheFileName]];
    [NSKeyedArchiver archiveRootObject:responseString toFile:filePath];
}

@end
