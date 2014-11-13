//
//  ViewController.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "ViewController.h"
#import "XTNetworkEngine.h"
#import "XTLog.h"
#import "RayWeather.h"
#import "XTNetworkEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchWeatherPressed:(id)sender
{
    RayWeatherRequest *request = [[RayWeatherRequest alloc] init];
    [[XTNetworkEngine defaultEngine] registerClientWithBaseURLString:[request baseURLString]];
    request.responseClassName = NSStringFromClass([RayWeatherResponse class]);
    [request startWithCallback:^(XTNetworkResponse *response) {
        RayWeatherResponse *weatherResponse = (RayWeatherResponse *)response;
        XTLog(XTL_INFO_LVL, @"ViewController", @"Response:%@ weather:%@", weatherResponse, weatherResponse.weather);
    }];
    [request start];
}

- (IBAction)fetchVersionPressed:(id)sender
{
//    XTNetworkRequest *request = [[XTNetworkRequest alloc] init];
//    request.path = @"checkUpgradeV382";
//    request.params = @{@"clientType": @(10),
//                       @"currentVersion":@"5.0,0",
//                       @"splashId":@(0),
//                       @"width":@(640),
//                       @"height":@(936),
//                       @"r":@([[NSDate date] timeIntervalSince1970]),
//                       @"partner":@14588,
//                       @"deviceType":@0,
//                       @"version":@"5.0.0"};
//    request.requestType = XTHTTPRequestTypeDynamicHTTP;
//    request.methodType = XTHTTPMethodGET;
//    request.responseObjectClassName = NSStringFromClass([XTVersion class]);
//    request.callback = ^(XTNetworkResponse *response){
//        XTLog(XTL_VERBOSE_LVL, @"ViewController", @"Response : %@", response);
//    };
//    [request start];

}


@end
