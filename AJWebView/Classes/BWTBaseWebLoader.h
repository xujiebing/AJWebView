//
//  BWTBaseWebLoader.h
//  QuickHybirdJSBridgeDemo
//
//  Created by guanhao on 2017/12/30.
//  Copyright © 2017年 com.gh. All rights reserved.
//

#import "BWTBaseViewController.h"
#import <MessageUI/MessageUI.h>

/**
 回调block
 */
typedef void(^CallBack)(NSString *);

@class WKWebView;

@interface BWTBaseWebLoader : BWTBaseViewController <MFMessageComposeViewControllerDelegate>

#pragma mark --- 暴露属性

/**
 webView
 */
@property (nonatomic, weak) WKWebView *wv;

/**
 传递参数的字典
 */
@property (nonatomic, strong) NSDictionary *params;


#pragma mark --- BWTJSPageApi

/**
 重新加载WKWebview
 */
- (void)reloadWKWebview;

#pragma mark --- BWTJSAuthApi

/**
 通过容器中持有的bridge属性注册API的方法，
 */
- (BOOL)registerHandlersWithClassName:(NSString *)className moduleName:(NSString *)moduleName;

@end
