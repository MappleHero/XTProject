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

static NSString *const categoryName = @"XTNetwork";

@interface XTNetworkEngine ()

@property (nonatomic, strong) NSMutableDictionary *managerDictionary;
@property (nonatomic, assign) XTRequestID maxRequestID;
@property (nonatomic, strong) NSMutableDictionary *operationDictionary;

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
        _operationDictionary = [NSMutableDictionary dictionary];
        // 999 ^_^, nothing special, just for fun
        _maxRequestID = 999;
    }
    return self;
}

#pragma mark - Request

- (BOOL)validateRequest:(XTNetworkRequest *)request error:(NSError **)error
{
    
    return YES;
}

- (void)addRequest:(XTNetworkRequest *)request
{
    request.requestID = ++self.maxRequestID;
    NSError *error = nil;
    XTLogVerbose(categoryName, @"Add request:{%@}", request);
    
    // Validate request
    if (![self validateRequest:request error:&error])
    {
        XTLogError(categoryName, @"Request:{%@} invalid!", request);

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
    
    NSMutableURLRequest *urlRequest = [manager.requestSerializer requestWithMethod:methodString
                                                                         URLString:[[NSURL URLWithString:request.path relativeToURL:manager.baseURL] absoluteString]
                                                                        parameters:request.params
                                                                             error:nil];
    if ([request requestURLString].length > 0) // Request custom the url string
    {
        urlRequest.URL = [NSURL URLWithString:[request requestURLString]];
    }

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
                                             
                                             // Dettach operation with requestID
                                             [self.operationDictionary removeObjectForKey:@(request.requestID)];
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
                                             
                                             // Dettach operation with requestID
                                             [self.operationDictionary removeObjectForKey:@(request.requestID)];
                                         }];
    // Attach operation with requestID
    self.operationDictionary[@(request.requestID)] = operation;
    [manager.operationQueue addOperation:operation];
}

- (void)removeRequest:(XTNetworkRequest *)request
{
    XTLogInfo(categoryName, @"Remove request:{%@}", request);
    AFHTTPRequestOperation *operation = self.operationDictionary[@(request.requestID)];
    [operation cancel];
    [self.operationDictionary removeObjectForKey:@(request.requestID)];
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
        XTLogWarn(categoryName, @"Request:{%@}, cache NOT exist", request);
        return nil;
    }
    
    // Validate cache
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                             error:&attributesRetrievalError];
    if (!attributes)
    {
        XTLogError(categoryName, @"Request:{%@}, failed to get file modification date");
        return nil;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    
    if (seconds > [request cacheInterval])
    {
        XTLogError(categoryName, @"Request:{%@}, cache EXPIRED");
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
