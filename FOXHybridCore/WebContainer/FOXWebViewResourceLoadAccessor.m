//
//  FOXWebViewResourceLoadAccessor.m
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/1.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import "FOXWebViewResourceLoadAccessor.h"

@implementation FOXWebViewResourceLoadAccessor

- (instancetype)initWithRequest:(NSURLRequest *)request type:(FOXWebViewResourceType)type {
    if (self = [super init]) {
        _request = request;
        _resourceType = type;
    }
    return self;
}

- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL type:(FOXWebViewResourceType)type {
    if (self = [super init]) {
        _HTMLString = HTMLString;
        _baseURL = baseURL;
        _resourceType = type;
    }
    return self;
}

- (instancetype)initWithLoadData:(NSData *)data
                        MIMEType:(NSString *)MIMEType
           characterEncodingName:(NSString *)characterEncodingName
                         baseURL:(NSURL *)baseURL
                            type:(FOXWebViewResourceType)type {
    if (self = [super init]) {
        _browserData = data;
        _MIMEType = MIMEType;
        _characterEncodingName = characterEncodingName;
        _baseURL = baseURL;
        _resourceType = type;
    }
    return self;
}


@end
