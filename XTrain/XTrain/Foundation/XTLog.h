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

@interface XTLogConfig : NSObject

/**
 *  初始化Log配置
 */
+ (void)loadConfig;

@end

//#define XTLog(level, category, fmt, ...) do{\
//    NSString *content = [[NSString alloc] initWithFormat:fmt, ##__VA_ARGS__];\
//    NSString *logContent = [NSString stringWithFormat:@"[%@:%d][%s][%@]",\
//    [[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent],\
//    __LINE__,\
//    __func__,\
//    category];\
//    switch (level)\
//    {\
//        case XTLogLevelVerbose:\
//            DDLogVerbose(@"%@[verbose] %@", logContent, content);\
//            break;\
//        case XTLogLevelDebug:\
//            DDLogVerbose(@"%@[Debug] %@", logContent, content);\
//            break;\
//        case XTLogLevelInfo:\
//            DDLogVerbose(@"%@[Info] %@", logContent, content);\
//            break;\
//        case XTLogLevelWarn:\
//            DDLogVerbose(@"%@[Warn] %@", logContent, content);\
//            break;\
//        case XTLogLevelError:\
//            DDLogVerbose(@"%@[Error] %@", logContent, content);\
//            break;\
//        default:\
//            break;\
//    }\
//}while(0)

