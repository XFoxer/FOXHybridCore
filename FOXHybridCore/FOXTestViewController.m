//
//  FOXTestViewController.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/2/24.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXTestViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "FOXRootViewController.h"


@interface FOXTestViewController ()

@end

@implementation FOXTestViewController

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self testJSValue];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)tapView:(UITapGestureRecognizer *)tap {
    FOXRootViewController *testRoot = [[FOXRootViewController alloc] init];
    [self.navigationController pushViewController:testRoot animated:YES];
}

- (BOOL)fox_hideNavigationBar {
    return YES;
}

- (void)testJSValue {
    JSContext *context = [[JSContext alloc] init];
    JSValue *value = [context evaluateScript:@"2+2"];
    NSLog(@"2 + 2 = %@", @([value toInt32]));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
