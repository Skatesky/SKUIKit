//
//  UIView+SKAlertView.h
//  MultiAlertViewDemo
//
//  Created by zhanghuabing on 16/9/6.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKAlertGroundView.h"
#import "SKAlertViewManager.h"

/**
 *  通过分类方法类管理弹出框
 */
@interface UIView (SKAlertView)

@property (strong, nonatomic) NSNumber *sk_alertIndexNum;

@property (assign, nonatomic) NSInteger sk_alertIndex;

@property (strong, nonatomic) SKAlertGroundView *sk_alertBaseView;

@property (strong, nonatomic) SKAlertViewManager *sk_alertManager;

#pragma mark - solution 1
- (void)sk_addAlertView:(UIView *)view atAlertIndex:(NSInteger)index;

- (void)sk_alertViewBringToFront;

#pragma mark - solution 2
/**
 带回调的弹框管理方法，如果调用此方法，需要在弹框消失的时候，调用sk_pop方法

 @param view 弹框视图
 @param alertIndex 层级
 @param show 显示回调
 */
- (void)sk_pushAlertView:(UIView *)view atAlertIndex:(NSInteger)alertIndex show:(RefreshBlock)show;

/**
 如果调用此方法，需要在弹框消失的时候，调用sk_pop方法

 @param view 弹框视图
 @param alertIndex 层级，值越高，层级越高
 */
- (void)sk_pushAlertView:(UIView *)view atAlertIndex:(NSInteger)alertIndex;

/**
 弹框视图退出栈

 @param view 弹框视图
 */
- (void)sk_popAlertView:(UIView *)view;

/**
 当前最上层的弹框退出栈
 */
- (void)sk_pop;

/**
 * 可以通过代理回调，定制自己的行为
 */
- (void)sk_setAlertViewDelegate:(id<SKAlertViewManagerDelegate>)alertDelegate;

@end
