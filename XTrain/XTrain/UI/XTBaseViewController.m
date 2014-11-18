//
//  XTBaseViewController.m
//  XTrain
//
//  Created by Ben on 14/11/18.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import "XTBaseViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import <JGProgressHUD/JGProgressHUDSuccessIndicatorView.h>
#import <JGProgressHUD/JGProgressHUDErrorIndicatorView.h>

static const int toastDuration = 2.0f;
static const JGProgressHUDStyle hudStyle = JGProgressHUDStyleDark;
static const JGProgressHUDInteractionType interactionType = JGProgressHUDInteractionTypeBlockAllTouches;

@interface XTBaseViewController ()

@property (nonatomic, strong) JGProgressHUD *loadingHUD;
@property (nonatomic, strong) JGProgressHUD *hintHUD;
@property (nonatomic, strong) JGProgressHUD *errorHUD;
@property (nonatomic, strong) JGProgressHUD *successHUD;
@property (nonatomic, strong) JGProgressHUD *warnHUD;

@end

@implementation XTBaseViewController

#pragma mark - HUD

- (JGProgressHUD *)commonHUD
{
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:hudStyle];
    HUD.interactionType = interactionType;
    return HUD;
}

- (JGProgressHUD *)loadingHUD
{
    if (_loadingHUD == nil)
    {
        _loadingHUD = [self commonHUD];
        _loadingHUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    }
    return _loadingHUD;
}

- (void)showLoadingView:(BOOL)show
{
    [self showLoadingView:show withText:@"加载中..."];
}

- (void)showLoadingView:(BOOL)show withText:(NSString *)text
{
    if (show && self.loadingHUD.visible)
    {
        return;
    }
    
    if (!show && !self.loadingHUD.visible)
    {
        return;
    }
    
    if (show)
    {
        self.loadingHUD.textLabel.text = text;
        [self.loadingHUD showInView:self.view];
    }
    else
    {
        [self.loadingHUD dismiss];
    }
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

- (JGProgressHUD *)hintHUD
{
    if (_hintHUD == nil)
    {
        _hintHUD = [self commonHUD];
        _hintHUD.indicatorView = nil;
        _hintHUD.position = JGProgressHUDPositionCenter;
    }
    return _hintHUD;
}

- (JGProgressHUD *)successHUD
{
    if (_successHUD == nil)
    {
        _successHUD = [self commonHUD];
        _successHUD.square = YES;
        if ([self successToastView])
        {
            JGProgressHUDIndicatorView *indicatorView = [[JGProgressHUDIndicatorView alloc] initWithContentView:[self successToastView]];
            _successHUD.indicatorView = indicatorView;
        }
        else
        {
            _successHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        }
    }
    return _successHUD;
}

- (JGProgressHUD *)warnHUD
{
    if (_warnHUD == nil)
    {
        _warnHUD = [self commonHUD];
    }
    return _warnHUD;
}

- (JGProgressHUD *)errorHUD
{
    if (_errorHUD == nil)
    {
        _errorHUD = [self commonHUD];
        _errorHUD.square = YES;
        
        if ([self errorToastView])
        {
            JGProgressHUDIndicatorView *indicatorView = [[JGProgressHUDIndicatorView alloc] initWithContentView:[self errorToastView]];
            _errorHUD.indicatorView = indicatorView;
        }
        else
        {
            _errorHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        }
    }
    return _errorHUD;
}

- (void)showToast:(NSString *)text type:(XTToastType)type duration:(CGFloat)duration
{
    JGProgressHUD *HUD = nil;
    
    switch (type)
    {
        case XTToastTypeHint:
            HUD = self.hintHUD;
            break;
        case XTToastTypeSuccess:
            HUD = self.successHUD;
            break;
        case XTToastTypeError:
            HUD = self.errorHUD;
            break;
        case XTToastTypeWarn:
            HUD = self.warnHUD;
            break;
        default:
            break;
    }
    
    if (HUD == nil)
    {
        return;
    }
    
    if (HUD.visible)
    {
        return;
    }
    
    HUD.textLabel.text = text;
    [HUD showInView:self.view];
    [HUD dismissAfterDelay:duration];
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
