//
//  UIViewController+FOXNavigationPopGesture.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/4.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "UIViewController+FOXNavigationPopGesture.h"
#import <objc/runtime.h>

@implementation UIViewController (FOXNavigationPopGesture)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleBarHidden];
        [self swizzlePopGesture];
    });
}

#pragma mark - PopGesture Delegate Set

+ (void)swizzlePopGesture {
    fox_swizzleMethod(self, @selector(viewDidLoad), @selector(fox_viewDidLoad));
}

- (void)fox_viewDidLoad {
    [self setFox_interactivePopMaxAllowedDistanceToLeftEdge:44.0f];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:(id)self];
    
    [self fox_viewDidLoad];
}

#pragma mark - NavigationBar Hidden

+ (void)swizzleBarHidden {
    fox_swizzleMethod(self,  @selector(viewWillAppear:), @selector(fox_viewWillAppear:));
}

- (void)fox_viewWillAppear:(BOOL)animated {
    [self fox_viewWillAppear:animated];
    
    NSLog(@"viewControlers == %@",self.navigationController.viewControllers);
    [self.navigationController setNavigationBarHidden:self.fox_hideNavigationBar animated:animated];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:!self.fox_interactivePopDisabled];
}

#pragma mark - Method Swizzle

void fox_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark - Accessor

- (void)setFox_hideNavigationBar:(BOOL)fox_hideNavigationBar {
    objc_setAssociatedObject(self, @selector(fox_hideNavigationBar), @(fox_hideNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fox_hideNavigationBar {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (void)setFox_interactivePopDisabled:(BOOL)fox_interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(fox_interactivePopDisabled), @(fox_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fox_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (void)setFox_interactivePopMaxAllowedDistanceToLeftEdge:(CGFloat)fox_interactivePopMaxAllowedDistanceToLeftEdge {
    objc_setAssociatedObject(self, @selector(fox_interactivePopMaxAllowedDistanceToLeftEdge), @(MAX(0,fox_interactivePopMaxAllowedDistanceToLeftEdge)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)fox_interactivePopMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

#pragma mark - Spectial View popGesture

- (void)fox_addPopGestureToView:(UIView *)view {
    if (!view) return;
    
    if (!self.navigationController) {
        /// 在控制器转场的时候，self.navigationController可能是nil,这里用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fox_addPopGestureToView:view];
        });
    } else {
        UIPanGestureRecognizer *panGesture = self.fox_popGestureRecognizer;
        if (![view.gestureRecognizers containsObject:panGesture]) {
            [view addGestureRecognizer:panGesture];
        }
    }
}

- (UIPanGestureRecognizer *)fox_popGestureRecognizer {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        NSArray *internalTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"targets"];
        id target = [internalTargets.firstObject valueForKey:@"target"];
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self.navigationController;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_ASSIGN);
    }
    return panGesture;
}
@end

#pragma mark  - FOXPopGesturePrivate

@interface UINavigationController (FOXPopGesturePrivate)


@end

@implementation UINavigationController (FOXPopGesturePrivate)


#pragma mark - GestureDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fox_interactivePopDisabled) {
        return NO;
    }
    
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedDistance = topViewController.fox_interactivePopMaxAllowedDistanceToLeftEdge;
    if (maxAllowedDistance > 0 && beginningLocation.x > maxAllowedDistance) {
        return NO;
    }

    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    if ([self.navigationController.transitionCoordinator isAnimated]) {
        return NO;
    }
    
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    
    return YES;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
