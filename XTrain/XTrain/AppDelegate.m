//
//  AppDelegate.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "AppDelegate.h"
#import "XTNetworkConfig.h"
#import "XTLog.h"
#import "XTUtil.h"
#import "TNServerURLConfig.h"
#import "XTNetworkEngine.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Log config
    [XTLogConfig loadConfig];
    // URL config
    [[TNServerURLConfig defaultConfig] loadConfig];
    // Cache path
    [XTNetworkConfig defaultConfig].HTTPCachePath = [[XTUtil appDocPath] stringByAppendingPathComponent:@"HTTPCache"];
    // Register client
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:@"http://www.raywenderlich.com/demos/weather_sample/"];
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:[TNServerURLConfig defaultConfig].HTTPURLString];
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:[TNServerURLConfig defaultConfig].dynamicHTTPURLString];
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:[TNServerURLConfig defaultConfig].HTTPSURLString];
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:[TNServerURLConfig defaultConfig].chatURLString];
    
    XTLog(XTL_VERBOSE_LVL, @"App Delegate", [XTUtil appDocPath]);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
