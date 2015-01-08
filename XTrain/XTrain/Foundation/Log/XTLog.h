//
//  XTLog.h
//  LogDemo
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 Tuniu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XTLogLevel)
{
    XTLogLevelVerbose = 0,
    XTLogLevelDebug,
    XTLogLevelInfo,
    XTLogLevelWarn,
    XTLogLevelError
};

#define XTL_VERBOSE_LVL   XTLogLevelVerbose,__FILE__,__LINE__,__func__
#define XTL_DEBUG_LVL   XTLogLevelDebug,__FILE__,__LINE__,__func__
#define XTL_INFO_LVL   XTLogLevelInfo,__FILE__,__LINE__,__func__
#define XTL_WARN_LVL   XTLogLevelWarn,__FILE__,__LINE__,__func__
#define XTL_ERROR_LVL   XTLogLevelError,__FILE__,__LINE__,__func__

FOUNDATION_EXPORT void XTLogout(XTLogLevel level, const char *file, int line, const char *func, NSString *category, NSString *fmt, ...);

#define XTLog XTLogout
#define XTLogVerbose(category, fmt, ...) XTLog(XTL_VERBOSE_LVL, category, fmt, ##__VA_ARGS__)
#define XTLogDebug(category, fmt, ...) XTLog(XTL_DEBUG_LVL, category, fmt, ##__VA_ARGS__)
#define XTLogInfo(category, fmt, ...) XTLog(XTL_INFO_LVL, category, fmt, ##__VA_ARGS__)
#define XTLogWarn(category, fmt, ...) XTLog(XTL_WARN_LVL, category, fmt, ##__VA_ARGS__)
#define XTLogError(category, fmt, ...) XTLog(XTL_ERROR_LVL, category, fmt, ##__VA_ARGS__)

@interface XTLogConfig : NSObject

/**
 *  初始化Log配置
 */
+ (void)loadConfig;

@end

