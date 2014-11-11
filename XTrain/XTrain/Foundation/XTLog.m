//
//  XTLog.m
//  XTrain
//
//  Created by Ben on 14/11/7.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTLog.h"
#import <DDLog.h>
#import <DDTTYLogger.h>
#import <DDFileLogger.h>
#import "XTUtil.h"

int ddLogLevel = LOG_LEVEL_VERBOSE;

void XTLogout(XTLogLevel level, const char *file, int line, const char *func, NSString *category, NSString *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    NSString *content = [[NSString alloc] initWithFormat:fmt arguments:ap];
    NSString *logContent = [NSString stringWithFormat:@"[%@:%d][%s][%@]",
                            [[NSString stringWithFormat:@"%s", file] lastPathComponent],
                            line,
                            func,
                            category];
    switch (level)
    {
        case XTLogLevelVerbose:
            DDLogVerbose(@"%@[verbose] %@", logContent, content);
            break;
        case XTLogLevelDebug:
            DDLogVerbose(@"%@[Debug] %@", logContent, content);
            break;
        case XTLogLevelInfo:
            DDLogVerbose(@"%@[Info] %@", logContent, content);
            break;
        case XTLogLevelWarn:
            DDLogVerbose(@"%@[Warn] %@", logContent, content);
            break;
        case XTLogLevelError:
            DDLogVerbose(@"%@[Error] %@", logContent, content);
            break;
        default:
            break;
    }
}

@implementation XTLogConfig

+ (void)loadConfig
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    NSString *directory = [[XTUtil appDocPath] stringByAppendingPathComponent:@"log"];
    DDLogFileManagerDefault *fileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:directory];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    [DDLog addLogger:fileLogger withLevel:LOG_LEVEL_ERROR];
}

@end