//
//  XTNetwork.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTNetwork.h"
#import <AFNetworking/AFNetworking.h>
#import "XTNetworkConfig.h"
#import <Mantle/Mantle.h>
#import "XTHTTPRequestSerializer.h"
#import "XTHTTPResponseSerializer.h"
#import "XTNetworkResponse.h"
#import "XTLog.h"

#define XTNETWORK_LOG_VERBOSE  XTL_VERBOSE_LVL,@"XTNetwork"
#define XTNETWORK_LOG_DEBUG  XTL_DEBUG_LVL,@"XTNetwork"
#define XTNETWORK_LOG_INFO  XTL_INFO_LVL,@"XTNetwork"
#define XTNETWORK_LOG_WARN  XTL_WARN_LVL,@"XTNetwork"
#define XTNETWORK_LOG_ERROR  XTL_ERROR_LVL,@"XTNetwork"

@interface XTNetwork ()

@property (nonatomic, strong) NSMutableDictionary *managerDictionary;

@end

@implementation XTNetwork

#pragma mark - Singletone

static XTNetwork *_defaultManager = nil;

+ (XTNetwork *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[super allocWithZone:NULL] init];
    });
    return _defaultManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self defaultManager];
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

        XTNetworkResponse *response = [[XTNetworkResponse alloc] init];
        response.error = error;
        dispatch_async(dispatch_get_main_queue(), ^{
            request.callback(response);
        });
        return;
    }
    
    if (request.cacheStrategy != XTHTTPCacheStrategyNetOnly
        && request.requestType != XTHTTPRequestTypeDynamicHTTP)
    {
        id cacheJSON = [self cachedJSONWithRequest:request];
        
        XTNetworkResponse *response = [[XTNetworkResponse alloc] init];
        response.success = YES;
        response.JSONString = cacheJSON[@"data"];
        response.fromCache = YES;
        NSError *error = nil;
        id object = [MTLJSONAdapter modelOfClass:NSClassFromString(request.responseObjectClassName)
                              fromJSONDictionary:cacheJSON
                                           error:&error];
        response.responseModel = object;
        response.error = error;
        dispatch_async(dispatch_get_main_queue(), ^{
            request.callback(response);
        });
        
    }
    
    if (request.cacheStrategy == XTHTTPCacheStrategyCacheOnly)
    {
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [self mangerWithRequestType:request.requestType];
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
                                             NSError *error = nil;
                                             
                                             id object = [MTLJSONAdapter modelOfClass:NSClassFromString(request.responseObjectClassName)
                                                                   fromJSONDictionary:responseObject[@"data"]
                                                                                error:&error];
                                             XTNetworkResponse *response = [[XTNetworkResponse alloc] init];
                                             response.success = YES;
                                             response.HTTPStatusCode = operation.response.statusCode;
                                             response.JSONString = responseObject;
                                             response.responseModel = object;
                                             response.error = error;
                                             if (request.callback)
                                             {
                                                 request.callback(response);
                                             }
                                             
                                             // cache
                                             if ([self requestShouldCache:request])
                                             {
                                                 [self cacheJSON:responseObject forRequest:request];
                                             }
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             XTNetworkResponse *response = [[XTNetworkResponse alloc] init];
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

- (AFHTTPRequestOperationManager *)mangerWithRequestType:(XTHTTPRequestType)type
{
    if (self.managerDictionary[@(type)])
    {
        return self.managerDictionary[@(type)];
    }
    
    NSString *baseUrlString = nil;
    switch (type)
    {
        case XTHTTPRequestTypeHTTP:
            baseUrlString = [XTNetworkConfig defaultConfig].HTTPUrlString;
            break;
        case XTHTTPRequestTypeDynamicHTTP:
            baseUrlString = [XTNetworkConfig defaultConfig].dynamicHTTPUrlString;
            break;
        case XTHTTPRequestTypeHTTPS:
            baseUrlString = [XTNetworkConfig defaultConfig].HTTPSUrlString;
            break;
        case XTHTTPRequestTypeCHAT:
            baseUrlString = [XTNetworkConfig defaultConfig].chatUrlString;
            break;
            
        default:
            break;
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlString]];
    manager.requestSerializer = [XTHTTPRequestSerializer serializer];
    manager.responseSerializer = [XTHTTPResponseSerializer serializer];
    self.managerDictionary[@(type)] = manager;
    return manager;
}

#pragma mark - Cache

- (BOOL)requestShouldCache:(XTNetworkRequest *)requset
{
    return requset.cacheInterval > 0 && requset.requestType != XTHTTPRequestTypeDynamicHTTP;
}

- (id)cachedJSONWithRequest:(XTNetworkRequest *)request
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
    
    if (seconds > request.cacheInterval)
    {
        XTLog(XTNETWORK_LOG_ERROR, @"Request:{%@}, cache EXPIRED");
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)cacheJSON:(id)responseObject forRequest:(XTNetworkRequest *)request
{
    NSString *filePath = [[XTNetworkConfig defaultConfig].HTTPCachePath stringByAppendingPathComponent:[request cacheFileName]];
    [NSKeyedArchiver archiveRootObject:responseObject toFile:filePath];
}

@end
