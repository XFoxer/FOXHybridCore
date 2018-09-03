//
//  FOXBridgeJSEnumeration.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/7.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * JS注册给OC调用的方法 bridgeName
 */

@interface FOXBridgeJSEnumeration : NSObject

@end

/* 设计思路  与JS 调用 OC类似 实际在Hybrid模块中OC调用JS的功能相对较小。核心还是JS调用OC的，这样Native端间接变成前端的底层，因此这一部分要规划好。
 * bridgeName 属于大的分层
 * params（inputData） 可以设置大模块下的子模块
 * 目前设想是这个模式，  具体还需要和前端商议确定
 */


typedef NSString * FOXJSBridgeOptionKey NS_STRING_ENUM;

FOUNDATION_EXPORT FOXJSBridgeOptionKey const FOXJSBridgeShowTipsKey;
FOUNDATION_EXPORT FOXJSBridgeOptionKey const FOXJSBridgeiFrameChangeKey;
FOUNDATION_EXPORT FOXJSBridgeOptionKey const FOXJSBridgeShowAlertKey;
