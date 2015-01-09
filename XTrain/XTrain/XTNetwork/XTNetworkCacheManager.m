//
//  XTNetworkCacheManager.m
//  XTrain
//
//  Created by Ben on 15/1/9.
//  Copyright (c) 2015年 XTeam. All rights reserved.
//

#import "XTNetworkCacheManager.h"
#import "XTNetworkRequest.h"
#import "XTNetworkConfig.h"
#import "XTLog.h"

@interface XTNetworkCacheManager ()

@property (nonatomic, strong) dispatch_queue_t operationQueue;

@end

@implementation XTNetworkCacheManager

#pragma mark - Singletone

static XTNetworkCacheManager *_defaultManager;

+ (XTNetworkCacheManager *)defaultManager
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

#pragma mark - Init & dealloc

- (id)init
{
    if (self = [super init])
    {
        _operationQueue = dispatch_queue_create("com.xt.CacheManagerQueue", 0);
    }
    return self;
}

#pragma mark - Handle cache

- (void)cacheData:(id)data forRequest:(XTNetworkRequest *)request;
{
    dispatch_async(self.operationQueue, ^{
        NSString *filePath = [[XTNetworkConfig defaultConfig].HTTPCachePath stringByAppendingPathComponent:[request cacheFileName]];
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    });
}

- (id)cachedDataWithRequest:(XTNetworkRequest *)request
{
    __block id cahedData = nil;
    dispatch_sync(self.operationQueue, ^{
        NSString *filePath = [[XTNetworkConfig defaultConfig].HTTPCachePath stringByAppendingPathComponent:[request cacheFileName]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil])
        {
            XTLogWarn(@"XTNetworkCacheManager", @"Request:{%@}, cache NOT exist", request);
        }
        
        // Validate cache
        NSError *attributesRetrievalError = nil;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                                    error:&attributesRetrievalError];
        if (!attributes)
        {
            XTLogError(@"XTNetworkCacheManager", @"Request:{%@}, failed to get file modification date");
        }
        NSTimeInterval seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
        
        if (seconds > [request cacheInterval])
        {
            XTLogError(@"XTNetworkCacheManager", @"Request:{%@}, cache EXPIRED");
        }
        
        cahedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    });
    
    return cahedData;
}

@end
