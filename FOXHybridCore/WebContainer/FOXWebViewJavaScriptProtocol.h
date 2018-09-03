//
//  FOXWebViewJavaScriptProtocol.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/7.
//  Copyright © 2018年 XFoxer. All rights reserved.
//




#ifndef FOXWebViewJavaScriptProtocol_h
#define FOXWebViewJavaScriptProtocol_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^WVBridgeResponseHander)(id responseData);

@protocol FOXWebViewJavaScriptProtocol <NSObject>


/**
 将要注册Bridge
 */
- (void)willRegisterBridgeForJavaScript;

/**
 *   OC注册供JS使用的方法，所有注册的bridge都写在这里
 */
- (void)registerBridgeForJavaScript;

/**
 已经注册Bridge完成
 */
- (void)didBeenRegisterBridgeForJavaScript;

@end


#endif /* FOXWebViewJavaScriptProtocol_h */
