//
//  FOXBridgeOCEnumeration.h.h
//  FOXHybridCore
//
//  Created by XFoxer on 2018/3/7.
//  Copyright © 2018年 XFoxer. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  OC注册给JS调用的方法 bridgeName
 */

@interface FOXBridgeOCEnumeration : NSObject

@end

/* 设计思路
 * bridgeName 属于大的分层，比如http，UI，device信息，account，localStorage，hardware等等
 * params（inputData） 可以设置大模块下的子模块
 * 比如设置 type字段，区分http请求是 get，post，getNA，postNA，再有其它参数给到完成这个请求需要的信息
   设置uiname字段，区分调用的是分享组件，发布组件等等，再有其它参数设置分享的内容，发布的的信息等等
 * 目前设想是这个模式，具体还需要和前端商议确定
 */


/**
 *  HTTP 请求分类 （get/post/getNA/postNA）区分具体是什么请求
 *  params 在js传递过来的参数中，配置请求url，参数，是否需要回调等等
 *  PS：也可以把请求类型放在 params中，这里这么设置，是为了划分模块切割的粒度 registerhandler ：FOXOCBridgeHTTPKey。实际配置情况还是要和前端商量好
 *  两者差异如下
 
 bridgeName ： FOXOCBridgeHTTPGetKey      ///medthod name
 params {
     url ：@"http://xxxx/getuserinfo/viplevel"
     userid : xxxx
 } /// body
 
 bridgeName： FOXOCBridgeHTTPKey       ///medthod name
 params {
     type: get
     paramer @{
         url ：@"http://xxxx/getuserinfo/viplevel"
         userid : xxxx
     }
 } /// body
 
 */
typedef NSString * FOXOCBridgeHTTPKey NS_STRING_ENUM;

FOUNDATION_EXPORT FOXOCBridgeHTTPKey const FOXOCBridgeHTTPGetKey;
FOUNDATION_EXPORT FOXOCBridgeHTTPKey const FOXOCBridgeHTTPPostKey;
FOUNDATION_EXPORT FOXOCBridgeHTTPKey const FOXOCBridgeHTTPGetNAKey;
FOUNDATION_EXPORT FOXOCBridgeHTTPKey const FOXOCBridgeHTTPPostNAKey;



/**
 *  UI 功能分类
 */
typedef NSString * FOXOCBridgeUIKey NS_STRING_ENUM;

FOUNDATION_EXPORT FOXOCBridgeUIKey const FOXOCBridgeUIShareKey;
FOUNDATION_EXPORT FOXOCBridgeUIKey const FOXOCBridgeUIToastKey;
FOUNDATION_EXPORT FOXOCBridgeUIKey const FOXOCBridgeUIAlertKey;
FOUNDATION_EXPORT FOXOCBridgeUIKey const FOXOCBridgeUIRefreshKey;
