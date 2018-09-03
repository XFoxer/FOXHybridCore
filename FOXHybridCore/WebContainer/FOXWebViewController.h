//
//  FOXWebViewController.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/2/27.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "FOXWebViewResourceLoadAccessor.h"
#import "FOXWebViewJavaScriptProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The Base WebView Controller, sample package...
 1.webView callback method   (DONE)
 2.header(Navigation) design （DONE）
 3.load progress, emptyDataSet   (DONE)
 4.OC && JS bridge
 
 For more feature todo:
 1.local data Store
 2.resource preLoad.
 */
@protocol FOXWebViewProtocol <NSObject>

@optional
- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType;
- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithResponse:(NSURLResponse *)response;
- (void)webViewDidStartLoad:(WKWebView *)webView;
- (void)webViewDidReceiveServerRedirect:(WKWebView *)webView;
- (void)webViewDidFinishLoad:(WKWebView *)webView;
- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler;

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler;

@end


@interface FOXWebViewController : UIViewController<FOXWebViewProtocol,FOXWebViewJavaScriptProtocol>

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) FOXWebViewResourceLoadAccessor *resourceAccessor;
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

@property (nonatomic) BOOL allowsInlineMediaPlayback;
@property (nonatomic) WKDataDetectorTypes dataDetectorTypes API_AVAILABLE(ios(10.0));

+ (instancetype)webViewControllerWithAddress:(NSString *)urlString;
+ (instancetype)webViewControllerWithURL:(NSURL *)URL;
+ (instancetype)webViewControllerWithURLRequest:(NSURLRequest *)request;
+ (instancetype)webViewControllerWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

- (instancetype)initWithAddress:(NSString *)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithLoadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL  API_AVAILABLE(ios(9.0)) NS_DESIGNATED_INITIALIZER;

- (instancetype)new  NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

///rightBarItems
- (void)setRightBarItems:(NSArray <UIBarButtonItem *> *)barItems;
- (void)removeRightBarItem:(UIBarButtonItem *)barItem;
- (void)removeAllRightBarItems;

/// reload
- (void)reload;
- (void)stopLoading;


/**
 OC register method for JS to call

 @param bridgeName OC register method name
 @param responseHandler OC receive the JS Call, the inputData（NSDictionary） as the method paramers. WVBridgeResponseHander callback for JS
  这里可以理解成JS传递了2个参数，一个Native完成JS发布任务需要的参数（inputData），一个把完成任务的结果回调给JS的block（callback）。
 */
- (void)registerBridgeName:(NSString *)bridgeName responseHandler:(void(^)(id inputData, WVBridgeResponseHander responseCallback))responseHandler;

/**
 OC call JS register function
 
 @param bridgeName JS register function name
 */
- (void)callBridgeName:(NSString *)bridgeName;

/**
 OC call JS register function
 
 @param bridgeName JS register function name
 @param inputData the paramers for JS function
 */
- (void)callBridgeName:(NSString *)bridgeName data:(id)inputData;

/**
 OC call JS register function
 
 @param bridgeName JS register function name
 @param inputData the paramers for JS function
 @param responseHandler JS callback for OC
 */
- (void)callBridgeName:(NSString *)bridgeName data:(id)inputData responseHandler:(WVBridgeResponseHander)responseHandler;

@end

NS_ASSUME_NONNULL_END
