//
//  XTBaseViewController.m
//  XTrain
//
//  Created by Ben on 14/11/18.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTBaseViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>

static const int toastDuration = 2.0f;

@interface XTBaseViewController ()

@end

@implementation XTBaseViewController

#pragma mark - HUD

- (void)showLoadingView:(BOOL)show
{
    [self showLoadingView:show withText:nil];
}

- (void)showLoadingView:(BOOL)show withText:(NSString *)text
{
    
}

- (UIView *)warnToastView
{
    return nil;
}

- (UIView *)successToastView
{
    return nil;
}

- (UIView *)errorToastView
{
    return nil;
}

- (void)showToast:(NSString *)text type:(XTToastType)type duration:(CGFloat)duration
{
    
}

- (void)showHintToast:(NSString *)text
{
    [self showHintToast:text duration:toastDuration];
}

- (void)showHintToast:(NSString *)text duration:(CGFloat)duration
{
    [self showToast:text type:XTToastTypeHint duration:duration];
}

- (void)showSuccessToast:(NSString *)text
{
    [self showSuccessToast:text duration:toastDuration];
}

- (void)showSuccessToast:(NSString *)text duration:(CGFloat)duration
{
    [self showToast:text type:XTToastTypeSuccess duration:duration];
}

- (void)showWarnToast:(NSString *)text
{
    [self showWarnToast:text duration:toastDuration];
}

- (void)showWarnToast:(NSString *)text duration:(CGFloat)duration
{
    [self showToast:text type:XTToastTypeWarn duration:duration];
}

- (void)showErrorToast:(NSString *)text
{
    [self showErrorToast:text duration:toastDuration];
}

- (void)showErrorToast:(NSString *)text duration:(CGFloat)duration
{
    [self showToast:text type:XTToastTypeError duration:duration];
}

#pragma mark - Content state

- (UIView *)contentErrorView
{
    // Subclass override
    return nil;
}

- (UIView *)contentEmptyView
{
    // Subclass override
    return nil;
}

@end
