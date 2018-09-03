//
//  FOXNavigationViewController.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/2.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXNavigationViewController.h"

@interface FOXNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation FOXNavigationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController.navigationController.viewControllers.count > 1) {
        viewController.navigationController.interactivePopGestureRecognizer.delegate = (id)viewController;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - Orientations

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


@end
