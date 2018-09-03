//
//  FOXWebBrowserViewController.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/2/28.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXWebBrowserViewController.h"
#import "FOXDataSetPlaceholderView+FOXFactory.h"
#import "FOXBridgeOCEnumeration.h"
#import "FOXBridgeJSEnumeration.h"

@interface FOXWebBrowserViewController ()<FOXDataSetPlaceholderViewDelegate>

@property (nonatomic, strong) FOXDataSetPlaceholderView *emptyDataSetView;

@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *searchBarButtonItem;

@end

@implementation FOXWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRightBarItems:@[self.refreshBarButtonItem,self.searchBarButtonItem]];
    [self.webView addSubview:[self emptyDataSetView]];
    [self.emptyDataSetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - FOXWebViewJavaScriptProtocol

/**
 All OC bridge should register here
 */
- (void)registerBridgeForJavaScript {
    [self registerBridgeName:@"testObjcCallback" responseHandler:^(id  _Nonnull inputData, WVBridgeResponseHander  _Nonnull responseCallback) {
        NSLog(@"bridge111");
        responseCallback(@{@"1234" : @"getAnswer"});
    }];
}

- (void)callBridgeInJavaScript {
    [self callBridgeName:@"testJavascriptHandler" data:@{@"foo" : @"bar"} responseHandler:^(id  _Nonnull responseData) {
        NSLog(@"bridge222");
    }];
}

#pragma mark - FOXWebViewProtocol

- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType{
    NSLog(@"WebViewShouldStartLoad: YES");
    return YES;
}

- (void)webViewDidStartLoad:(WKWebView *)webView {
    NSLog(@"WebViewStartLoad");
    [self showEmptyDataSetView:NO];
}

- (void)webViewDidFinishLoad:(WKWebView *)webView {
    NSLog(@"WebViewLoadFinish");
}

- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"WebViewLoadError: %@",[error description]);
    
    /** error ignore
     *  1.异步加载的时候取消返回，当它执行取消操作上加载资源时，Web工具包框架委托将收到此错误。webView可忽略此错误
     *  2.包含有未转义字符的URL链接会报错101，Domain ：WebKitErrorDomain
     */
    if (error.code == NSURLErrorCancelled || ([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 101)) {
        return;
    }
    
    if ([error code] == -1009) {
        //网络连接已断开, Show Toast
        NSLog(@"电波无法到达");
    } else {
        [self showEmptyDataSetView:YES];
    }
}

#pragma mark - UIBarButtonItem

- (UIBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadTapped:)];
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)searchBarButtonItem {
    if (!_searchBarButtonItem) {
        _searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(seachBarDidClick:)];
    }
    return _searchBarButtonItem;
}


- (void)reloadTapped:(UIBarButtonItem *)buttonItem {
    [self reload];
}

- (void)seachBarDidClick:(UIBarButtonItem *)searchItem {
    [self callBridgeInJavaScript];
}

#pragma mark - EmptyDataSet

- (FOXDataSetPlaceholderView *)emptyDataSetView {
    if (!_emptyDataSetView) {
        _emptyDataSetView = [FOXDataSetPlaceholderView defaultPlaceholder];
        _emptyDataSetView.delegate = self;
        _emptyDataSetView.alpha = 0.0f;
    }
    return _emptyDataSetView;
}

- (void)placeholderView:(FOXDataSetPlaceholderView *)holderView didTapView:(UIView *)view {
    [self reload];
}

- (void)showEmptyDataSetView:(BOOL)show {
    CGFloat viewAlpha = show ? 1.0f : 0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        [self.emptyDataSetView setAlpha:viewAlpha];
    } completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
