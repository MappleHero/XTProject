//
//  XTUncaughtExceptionHandler.m
//  TuniuSelfDriving
//
//  Created by Ben on 14/12/15.
//  Copyright (c) 2014年 Tuniu. All rights reserved.
//

#import "XTUncaughtExceptionHandler.h"
#import "XTUtil.h"

static NSDateFormatter *dateFormatter = nil;

void handleException(NSException *exception)
{
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *crashInfo = [NSString stringWithFormat:@"================= Crash Report =================\n"
                           "Name:%@\n"
                           "Reason:%@\n"
                           "Call stack symbols:\n%@",
                           name, reason, [callStack componentsJoinedByString:@"\n"]];
    NSString *docPath = [XTUtil appDocPath];
    
    NSString *crashFileDirectory = [docPath stringByAppendingPathComponent:@"Crash"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:crashFileDirectory])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:crashFileDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }
    
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSString *filePath = [crashFileDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.txt", [dateFormatter stringFromDate:[NSDate date]]]];
    
    [crashInfo writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@implementation XTUncaughtExceptionHandler

+ (void)initHandler
{
    NSSetUncaughtExceptionHandler(&handleException);
}

@end




