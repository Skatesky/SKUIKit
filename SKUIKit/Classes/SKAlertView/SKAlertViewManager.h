//
//  SKAlertViewManager.h
//  MultiAlertViewDemo
//
//  Created by zhanghuabing on 16/9/7.
//  Copyright © 2016年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SKAlertViewManagerDelegate <NSObject>

- (void)showAlertView:(nullable UIView *)alertView;

@end

typedef void(^RefreshBlock)(UIView *topAlertView);

@interface SKAlertViewManager : NSObject

@property (weak, nonatomic) id<SKAlertViewManagerDelegate> alertViewDelegate;

- (void)pushAlertView:(UIView *)alertView atIndex:(NSInteger)index top:(nullable RefreshBlock)top;

- (void)pushAlertView:(UIView *)alertView atIndex:(NSInteger)index;

- (void)popAlertView:(UIView *)alertView;

- (void)pop;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
