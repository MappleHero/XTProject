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
#import "TNVersion.h"
#import <Masonry/Masonry.h>
#import "NSAttributedString+EasyToUse.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleLoading:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    [self showLoadingView:!button.selected];
}

- (IBAction)showSuccess:(id)sender
{
    [self showSuccessToast:@"成功"];
}

- (IBAction)showError:(id)sender
{
    [self showErrorToast:@"失败"];
}

- (IBAction)showHint:(id)sender
{
    [self showHintToast:@"Hello world..."];
}

- (IBAction)fetchWeatherPressed:(id)sender
{
    RayWeatherRequest *request = [[RayWeatherRequest alloc] init];
    request.responseClassName = NSStringFromClass([RayWeatherResponse class]);
    [request startWithCallback:^(XTNetworkResponse *response) {
        RayWeatherResponse *weatherResponse = (RayWeatherResponse *)response;
        XTLog(XTL_INFO_LVL, @"ViewController", @"Response:%@ weather:%@", weatherResponse, weatherResponse.weather);
    }];
}

- (IBAction)fetchVersionPressed:(id)sender
{
    TNVersionRequest *request = [[TNVersionRequest alloc] init];
    request.responseClassName = NSStringFromClass([TNVersionResponse class]);
    [request startWithCallback:^(XTNetworkResponse *response) {
        TNVersionResponse *versionResponse = (TNVersionResponse *)response;
        XTLog(XTL_INFO_LVL, @"ViewController", @"Response:%@ model:%@", versionResponse, versionResponse.model);
    }];
}


@end
