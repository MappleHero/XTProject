//
//  ViewController.m
//  XTrain
//
//  Created by Ben on 14/11/6.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "ViewController.h"
#import "XTNetwork.h"
#import "XTNetworkRequest.h"
#import "XTVersion.h"

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

- (IBAction)fetchJsonPressed:(id)sender
{
    XTNetworkRequest *request = [[XTNetworkRequest alloc] init];
    request.path = @"checkUpgradeV382";
    request.params = @{@"clientType": @(10),
                       @"currentVersion":@"5.0,0",
                       @"splashId":@(0),
                       @"width":@(640),
                       @"height":@(936),
                       @"r":@([[NSDate date] timeIntervalSince1970]),
                       @"partner":@14588,
                       @"deviceType":@0,
                       @"version":@"5.0.0"};
    request.requestType = XTHTTPRequestTypeDynamicHTTP;
    request.methodType = XTHTTPMethodGET;
    request.responseObjectClassName = NSStringFromClass([XTVersion class]);
    request.callback = ^(id responseObject, NSError *error){
        NSLog(@"%@ %@", responseObject, error);
    };
    [[XTNetwork defaultManager] sendRequest:request];
}


@end
