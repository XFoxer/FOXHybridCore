//
//  FOXWebViewController.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/2/27.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXWebViewController.h"
#import "FOXProgressView.h"
#import "WKWebViewJavascriptBridge.h"

static NSString *kBiliLiveInjectBridgeName = @"biliLiveJSInject";

///WebView Delegate 转发器，转发回 WebViewController
@interface FOXWebViewDelegateTransponder : NSObject <FOXWebViewProtocol, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) id<FOXWebViewProtocol>delegate;

@end

@implementation FOXWebViewDelegateTransponder

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        [(UIViewController *)self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(YES);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }]];
        [(UIViewController *)self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [self.delegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:prompt preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setFont:[UIFont systemFontOfSize:16]];
            [textField setTextAlignment:NSTextAlignmentCenter];
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            completionHandler(textField.text);
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(@"");
        }]];
        [(UIViewController *)self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        BOOL result = [self.delegate webView:webView shouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
        decisionHandler(result);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithResponse:)]) {
        BOOL result = [self.delegate webView:webView shouldStartLoadWithResponse:navigationResponse.response];
        decisionHandler(result);
    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewDidReceiveServerRedirect:)]) {
        [self.delegate webViewDidReceiveServerRedirect:webView];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.delegate && [self.delegate  respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [self.delegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

@end



@interface FOXWeakScriptMessageController :UIViewController<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> messageHandler;

@end

@implementation FOXWeakScriptMessageController

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.messageHandler && [self.messageHandler respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.messageHandler userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end


@interface FOXWebViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) id<FOXWebViewProtocol>delegate;
@property (nonatomic, strong) FOXWebViewDelegateTransponder *transponder;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@property (nonatomic, strong, readwrite) WKWebView *webView;
@property (nonatomic, strong, readwrite) FOXWebViewResourceLoadAccessor *resourceAccessor;

@property (nonatomic, strong) FOXProgressView *progressView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *forwardBarButtonItem;

@end

@implementation FOXWebViewController

#pragma mark - Initialization

+ (instancetype)webViewControllerWithAddress:(NSString *)urlString {
    return [[self alloc] initWithAddress:urlString];
}

+ (instancetype)webViewControllerWithURL:(NSURL *)URL {
    return [[self alloc] initWithURL:URL];
}

+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request {
    return [[self alloc] initWithURLRequest:request];
}

+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    return [[self alloc] initWithHTMLString:HTMLString baseURL:baseURL];
}

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.resourceAccessor = [[FOXWebViewResourceLoadAccessor alloc] initWithRequest:request type:FOXWebViewRemoteBrowserResourceType];
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.resourceAccessor = [[FOXWebViewResourceLoadAccessor alloc] initWithHTMLString:HTMLString baseURL:baseURL type:FOXWebViewHTMLResourceType];
    }
    return self;
}

- (instancetype)initWithLoadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.resourceAccessor = [[FOXWebViewResourceLoadAccessor alloc] initWithLoadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL type:FOXWebViewDataResourceType];
    }
    return self;
}

- (void)loadRequest:(NSURLRequest *)request {
    [self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL {
    [self.webView loadHTMLString:string baseURL:baseURL];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL {
    if (@available(iOS 9.0, *)) {
        [self.webView loadData:data MIMEType:MIMEType characterEncodingName:characterEncodingName baseURL:baseURL];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    self.delegate = nil;
    self.transponder = nil;
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kBiliLiveInjectBridgeName];
    [self removeViewObservers];
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItems  = @[self.backBarButtonItem,self.forwardBarButtonItem];
    [self initializeBridge];
    [self addViewObservers];
    [self loadWebSource];
}

- (void)initializeBridge {
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self.transponder];
    
    [self willRegisterBridgeForJavaScript];
    [self registerBridgeForJavaScript];
    [self didBeenRegisterBridgeForJavaScript];
}

- (void)loadWebSource {
    switch (self.resourceAccessor.resourceType) {
        case FOXWebViewRemoteBrowserResourceType:
        {
            [self loadRequest:self.resourceAccessor.request];
        }
            break;
        case FOXWebViewHTMLResourceType:
        {
            [self loadHTMLString:self.resourceAccessor.HTMLString baseURL:self.resourceAccessor.baseURL];
        }
            break;
        case FOXWebViewDataResourceType:
        {
            [self loadData:self.resourceAccessor.browserData MIMEType:self.resourceAccessor.MIMEType characterEncodingName:self.resourceAccessor.characterEncodingName baseURL:self.resourceAccessor.baseURL];
        }
            break;
            
        default:
            break;
    }
}

- (FOXWebViewDelegateTransponder *)transponder {
    if (!_transponder) {
        _transponder = [[FOXWebViewDelegateTransponder alloc] init];
        _transponder.delegate = self;
    }
    return _transponder;
}


- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
        webViewConfig.userContentController  = [self userContentContainer];
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.UIDelegate = self.transponder;
        _webView.navigationDelegate = self.transponder;
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (WKUserContentController *)userContentContainer {
    WKUserContentController *userContentContainer = [[WKUserContentController alloc] init];
    
    //设置JS与OC交互Handler
    FOXWeakScriptMessageController *scriptMessageHander = [[FOXWeakScriptMessageController alloc] init];
    [scriptMessageHander setMessageHandler:self];
    [userContentContainer addScriptMessageHandler:scriptMessageHander name:kBiliLiveInjectBridgeName];
    
    //注入初始JS与OC交互信息
    NSString *JSPath = [[self JSBundle] pathForResource:[self injectJSFileName] ofType:@"js"];
    NSError *error;
    NSString *bridgeJS = [NSString stringWithContentsOfFile:JSPath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:bridgeJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentContainer addUserScript:userScript];
    }
    return userContentContainer;
}

- (NSBundle *)JSBundle {
    return [NSBundle bundleForClass:[self class]];
}

- (NSString *)injectJSFileName {
    return @"foxwebview_bridge_inject";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.progressView cancelLoadProgress];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark - WebView Progress

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.progressView.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.frame.size.width, 0.5);
}

- (FOXProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[FOXProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - UIBarButttonItem

- (UIBarButtonItem *)backBarButtonItem {
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton = [self createBackView]];
        _backBarButtonItem.width = -7;
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backForwardItem:)];
        [_forwardBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15] } forState:UIControlStateNormal];;
    }
    return _forwardBarButtonItem;
}


- (UIButton *)createBackView {
    UIImage *backImage = [UIImage imageNamed:@"webBack"];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn setImage:backImage forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backBtn addTarget:self action:@selector(popBrowserView:) forControlEvents:UIControlEventTouchUpInside];;
    return backBtn;
}

- (void)setRightBarItems:(NSArray <UIBarButtonItem *> *)barItems {
    self.navigationItem.rightBarButtonItems = barItems;
}

- (void)removeRightBarItem:(UIBarButtonItem *)barItem {
    NSMutableArray <UIBarButtonItem *> *rightBarItems = [[NSMutableArray alloc] initWithArray:[self.navigationItem.rightBarButtonItems copy]];
    if ([rightBarItems containsObject:barItem]) {
        [rightBarItems removeObject:barItem];
    }
    self.navigationItem.rightBarButtonItems = rightBarItems;
}

- (void)removeAllRightBarItems {
    self.navigationItem.rightBarButtonItems = nil;
}

#pragma mark - TargetActions

- (void)popBrowserView:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backForwardItem:(UIBarButtonItem *)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - KVO Observer

- (void)addViewObservers {
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeViewObservers {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isKindOfClass:[WKWebView class]]) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            [self.progressView loadProgress:self.webView.estimatedProgress animated:YES];
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            if (self.webView.canGoBack) {
                [self.forwardBarButtonItem setEnabled:YES];
                [self.forwardBarButtonItem setTitle:@"返回"];
                [self.backButton setTitle:@"关闭" forState:UIControlStateNormal];
            } else {
                [self.forwardBarButtonItem setEnabled:NO];
                [self.forwardBarButtonItem setTitle:@""];
                [self.backButton setTitle:@"" forState:UIControlStateNormal];
            }
        } else if ([keyPath isEqualToString:@"title"]) {
            self.title = [NSString stringWithFormat:@"%@",change[NSKeyValueChangeNewKey]];
        }
    }
}

#pragma mark - WKScriptMessageHander

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.webView evaluateJavaScript:message.body completionHandler:^(id _Nullable message, NSError * _Nullable error) {
        
    }];
}

#pragma mark - FOXWebViewJavaScriptProtocol

- (void)willRegisterBridgeForJavaScript {
    NSLog(@"Will registerBridgeForJavaScript");
}


- (void)registerBridgeForJavaScript {
    NSLog(@"Register registerBridgeForJavaScript");
}

- (void)didBeenRegisterBridgeForJavaScript {
    NSLog(@"Did Been registerBridgeForJavaScript");
}

#pragma mark - OBJC & JS Bridge

- (void)registerBridgeName:(NSString *)bridgeName responseHandler:(void(^)(id inputData, WVBridgeResponseHander responseCallback))responseHandler {
    [self.bridge registerHandler:bridgeName handler:^(id data, WVJBResponseCallback responseCallback) {
        if(responseHandler) {
           responseHandler(data,responseCallback);
        }
    }];
}

- (void)callBridgeName:(NSString *)bridgeName {
    [self.bridge callHandler:bridgeName];
}

- (void)callBridgeName:(NSString *)bridgeName data:(id)data {
    [self.bridge callHandler:bridgeName data:data];
}

- (void)callBridgeName:(NSString *)bridgeName data:(id)inputData responseHandler:(WVBridgeResponseHander)responseHandler {
    [self.bridge callHandler:bridgeName data:inputData responseCallback:^(id responseData) {
        if(responseHandler) {
           responseHandler(responseData);
        }
    }];
}

#pragma mark - Setter

- (void)setAllowsInlineMediaPlayback:(BOOL)allowsInlineMediaPlayback {
    [self.webView.configuration setAllowsInlineMediaPlayback:allowsInlineMediaPlayback];
}

- (void)setDataDetectorTypes:(WKDataDetectorTypes)dataDetectorTypes {
    [self.webView.configuration setDataDetectorTypes:dataDetectorTypes];
}

#pragma mark - Getter

- (BOOL)isLoading {
    return self.webView.isLoading;
}

#pragma mark - Public Methods

- (void)reload {
    switch (self.resourceAccessor.resourceType) {
        case FOXWebViewRemoteBrowserResourceType:
        {
            WKBackForwardListItem *currentItem = self.webView.backForwardList.currentItem;
            NSURLRequest *currentItemRequest = [NSURLRequest requestWithURL:currentItem.URL];
            if (currentItem.URL) {
                [self loadRequest:currentItemRequest];
            } else {
                [self loadRequest:self.resourceAccessor.request];
            }
        }
            break;
        case FOXWebViewHTMLResourceType:
        {
            [self loadHTMLString:self.resourceAccessor.HTMLString baseURL:self.resourceAccessor.baseURL];
        }
            break;
        case FOXWebViewDataResourceType:
        {
            [self loadData:self.resourceAccessor.browserData MIMEType:self.resourceAccessor.MIMEType characterEncodingName:self.resourceAccessor.characterEncodingName baseURL:self.resourceAccessor.baseURL];
        }
            break;
            
        default:
            break;
    }
}

- (void)stopLoading {
    [self.webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
