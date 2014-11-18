//
//  XTBaseViewController.h
//  XTrain
//
//  Created by Ben on 14/11/18.
//  Copyright (c) 2014年 XTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XTToastType)
{
    XTToastTypeHint = 0,
    XTToastTypeSuccess,
    XTToastTypeError,
    XTToastTypeWarn
};

@interface XTBaseViewController : UIViewController

#pragma mark - Load state

- (void)showLoadingView:(BOOL)show;

- (void)showLoadingView:(BOOL)show withText:(NSString *)text;

#pragma mark - Toast

- (void)showHintToast:(NSString *)text;

- (void)showHintToast:(NSString *)text duration:(CGFloat)duration;

- (void)showSuccessToast:(NSString *)text;

- (void)showSuccessToast:(NSString *)text duration:(CGFloat)duration;

- (void)showErrorToast:(NSString *)text;

- (void)showErrorToast:(NSString *)text duration:(CGFloat)duration;

- (void)showWarnToast:(NSString *)text;

- (void)showWarnToast:(NSString *)text duration:(CGFloat)duration;

- (void)showToast:(NSString *)text type:(XTToastType)type duration:(CGFloat)duration;

- (UIView *)errorToastView;

- (UIView *)successToastView;

- (UIView *)warnToastView;

#pragma mark - Content state

/**
 *  错误页面，子类覆写
 *
 *  @return 错误页面
 */
- (UIView *)contentErrorView;

/**
 *  空页面，子类覆写
 *
 *  @return 空页面
 */
- (UIView *)contentEmptyView;

@end
