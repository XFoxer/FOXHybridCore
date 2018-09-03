//
//  FOXWebViewResourceLoadAccessor.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/1.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 WebView Resources Accessor
 */

typedef NS_ENUM(NSUInteger,FOXWebViewResourceType) {
    FOXWebViewRemoteBrowserResourceType,  ///远程网页端数据
    FOXWebViewHTMLResourceType,           ///本地HTML数据
    FOXWebViewDataResourceType,           ///二进制数据
};


@interface FOXWebViewResourceLoadAccessor : NSObject
@property (nonatomic, assign) FOXWebViewResourceType resourceType;

/** BrowserResourceType，origin request（first request） */
@property (nonatomic, strong) NSURLRequest *request;

/** HTMLResourceType */
@property (nonatomic, strong) NSString *HTMLString;

/** DataResourceType */
@property (nonatomic, strong) NSData *browserData;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, strong) NSString *characterEncodingName;

@property (nonatomic, strong) NSURL *baseURL;

- (instancetype)initWithRequest:(NSURLRequest *)request type:(FOXWebViewResourceType)type;
- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL type:(FOXWebViewResourceType)type;
- (instancetype)initWithLoadData:(NSData *)data
                        MIMEType:(NSString *)MIMEType
           characterEncodingName:(NSString *)characterEncodingName
                         baseURL:(NSURL *)baseURL
                            type:(FOXWebViewResourceType)type;

@end
