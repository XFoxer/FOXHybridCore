//
//  UIViewController+FOXNavigationPopGesture.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/4.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FOXNavigationPopGesture) <UIGestureRecognizerDelegate>

/** Disable pop gesture or not, default is NO  */
@property (nonatomic, assign) BOOL fox_interactivePopDisabled;

/** Hide navigationBar or not, default is NO */
@property (nonatomic, assign) BOOL fox_hideNavigationBar;

/** Gesture recognizer distance, default is 44.0f px */
@property (nonatomic, assign) CGFloat fox_interactivePopMaxAllowedDistanceToLeftEdge;

/** Add pop gesture for spectial view, like UIScrollView, WKWebView, WKMapView etc*/
- (void)fox_addPopGestureToView:(UIView *)view;

@end

