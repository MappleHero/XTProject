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

- (void)sendRequest:(XTNetworkRequest *)request
{
    NSError *error = nil;
    // Validate request
    if (![self validateRequest:request error:&error])
    {
        request.callback(nil, error);
        return;
    }
    
    if (request.cacheStrategy != XTHTTPCacheStrategyNetOnly)
    {
        // TODO:Output cache
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
                                             NSLog(@"request:%@\nresponse:%@", request, responseObject);
                                             NSError *error = nil;
                                             id object = [MTLJSONAdapter modelOfClass:NSClassFromString(request.responseObjectClassName)
                                                                   fromJSONDictionary:responseObject[@"data"]
                                                                                error:&error];
                                             if (request.callback)
                                             {
                                                 request.callback(object, error);
                                             }
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (request.callback)
                                             {
                                                 request.callback(nil, error);
                                             }
                                         }];
    
    [manager.operationQueue addOperation:operation];
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

@end
