//
//  XTBaseViewController.m
//  XTrain
//
//  Created by Ben on 14/11/18.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTBaseViewController.h"

static const int toastDuration = 2.0f;

@implementation XTBaseViewController

#pragma mark - Load state

- (void)showLoadingView:(BOOL)show
{
    [self showLoadingView:show withText:nil];
}

- (void)showLoadingView:(BOOL)show withText:(NSString *)text
{
    
}

#pragma mark - Toast

- (void)showToast:(NSString *)text type:(XTToastType)type duration:(CGFloat)duration
{
    
}

- (void)showHintToast:(NSString *)text
{
    
}

- (void)showHintToast:(NSString *)text duration:(CGFloat)duration
{
    
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
    
}

- (void)showWarnToast:(NSString *)text duration:(CGFloat)duration
{
    
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
