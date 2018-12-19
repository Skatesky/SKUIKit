//
//  SKAlertViewManager.m
//  MultiAlertViewDemo
//
//  Created by zhanghuabing on 16/9/7.
//  Copyright © 2016年 test. All rights reserved.
//

#import "SKAlertViewManager.h"
#import "UIView+SKAlertView.h"

@interface SKAlertViewManager ()

@property (strong, nonatomic) NSMutableArray *alertViews;
@property (strong, nonatomic) NSMutableDictionary *callBacks;    // 回调

@end

@implementation SKAlertViewManager

- (NSMutableArray *)alertViews {
    if (!_alertViews) {
        _alertViews = [[NSMutableArray alloc] init];
    }
    return _alertViews;
}

- (NSMutableDictionary *)callBacks {
    if (!_callBacks) {
        _callBacks = [[NSMutableDictionary alloc] init];
    }
    return _callBacks;
}

- (void)pushAlertView:(UIView *)alertView atIndex:(NSInteger)index {
    [self pushAlertView:alertView atIndex:index top:nil];
}

- (void)pushAlertView:(UIView *)alertView atIndex:(NSInteger)index top:(nullable RefreshBlock)top {
    alertView.sk_alertIndex = index;
    alertView.hidden    = YES;
    //先隐藏顶部视图
    NSInteger showIndex = [self topViewIndex];
    if (showIndex >= 0) {
        UIView *showView    = self.alertViews[showIndex];
        showView.hidden     = YES;
    }
    //寻找合适的地方插入新的视图
    if (!_alertViews || index < 0) {
        [self.alertViews addObject:alertView];
    } else {
        NSInteger currentIndex = [self searchIndexForViewAlertIndex:index];
        if (currentIndex >= self.alertViews.count) {
            [self.alertViews addObject:alertView];
        } else {
            [self.alertViews insertObject:alertView atIndex:currentIndex];
        }
    }
    
    if (top) {
        [self.callBacks setObject:top forKey:@(index)];
    }
    
    [self refresh];
}

- (void)popAlertView:(UIView *)alertView {
    if (!alertView) {
        return;
    }
    [_alertViews removeObject:alertView];
    [_callBacks removeObjectForKey:@(alertView.sk_alertIndex)];
    [self refresh];
}

- (void)pop {
    if (_alertViews.count == 1) {
        [_alertViews removeAllObjects];
        _alertViews = nil;
        [_callBacks removeAllObjects];
        _callBacks = nil;
    } else {
        [self refresh];
    }
}

- (void)refresh {
    //显示顶部视图
    NSInteger showIndex = [self topViewIndex];
    if (showIndex < 0) {
        [_alertViews removeAllObjects];
        [_callBacks removeAllObjects];
        return;
    }
    UIView *showView    = self.alertViews[showIndex];
    showView.hidden     = NO;
    
    // delegate 回调
    if (_alertViewDelegate && [_alertViewDelegate respondsToSelector:@selector(showAlertView:)]) {
        [_alertViewDelegate showAlertView:showView];
    }
    
    // block 回调
    RefreshBlock top = [self.callBacks objectForKey:@(showView.sk_alertIndex)];
    if (top) {
        top(showView);
    }
    
    // 移除已经消失的更高层级的视图
    if (showIndex < self.alertViews.count - 1) {
        UIView *rmView = [self.alertViews lastObject];
        if (rmView) {
            [self.callBacks removeObjectForKey:@(rmView.sk_alertIndex)];
            [self.alertViews removeObject:rmView];
        }
    }
}

#pragma mark - private methods
- (NSInteger)searchIndexForViewAlertIndex:(NSInteger)alertIndex {
    NSInteger searchIndex = 0;
    while (searchIndex < self.alertViews.count) {
        UIView *aView = self.alertViews[searchIndex];
        if (aView.sk_alertIndex > alertIndex) {
            break;
        } else {
            searchIndex++;
        }
    }
    return searchIndex;
}

- (NSInteger)topViewIndex {
    NSInteger index = self.alertViews.count - 1;
    for (; index >= 0; index--) {
        UIView *aView = self.alertViews[index];
        if (aView && aView.superview) {
            break;
        }
    }
    return index;
}

@end
