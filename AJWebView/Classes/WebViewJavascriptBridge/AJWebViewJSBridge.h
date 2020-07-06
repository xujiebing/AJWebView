//
//  AJWebViewJSBridge.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import <Foundation/Foundation.h>
#import "AJWebViewJSBridgeBase.h"
#import <WebKit/WebKit.h>

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsWKWebKit
#endif

#if defined(supportsWKWebKit)


NS_ASSUME_NONNULL_BEGIN

@interface AJWebViewJSBridge : NSObject <AJWebViewJSBridgeBaseDelegate, WKScriptMessageHandler>

+ (instancetype)bridgeForWebView:(WKWebView*)webView;
+ (void)enableLogging;

- (void)reset;
- (void)setWebViewDelegate:(id<WKNavigationDelegate>)webViewDelegate;

/// WKWebView批量注册框架API方法
- (void)registerFrameAPI;

/// 注册API
/// @param className API类名
/// @param moduleName API所属模块
- (BOOL)registerHandlersWithClassName:(NSString *)className moduleName:(NSString *)moduleName;

/// 统一异常回调方法
/// @param errorCode 错误码
/// @param errorUrl 错误的Url
/// @param errorDescription 错误描述
- (void)handleErrorWithCode:(NSInteger)errorCode
                   errorUrl:(NSString *)errorUrl
           errorDescription:(NSString *)errorDescription;

/// 获取页面内临时缓存的数据或方法
/// @param moduleName 框架API模块名称
/// @param keyName key
- (id)objectForKeyInCacheDicWithModuleName:(NSString *)moduleName
                                   KeyName:(NSString *)keyName;

/// 删除页面内临时缓存的数据或方法
/// @param moduleName 框架API模块名称
/// @param keyName key
- (void)removeObjectForKeyInCacheDicWithModuleName:(NSString *)moduleName
                                           KeyName:(NSString *)keyName;

/// 是否包含指定的value值
/// @param moduleName 框架API模块名称
/// @param keyName key
- (BOOL)containObjectForKeyInCacheDicWithModuleName:(NSString *)moduleName
                                            KeyName:(NSString *)keyName;

@end

#endif

NS_ASSUME_NONNULL_END
