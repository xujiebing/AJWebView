//
//  AJBaseWebLoader.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/4.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class WKWebView;

NS_ASSUME_NONNULL_BEGIN

@interface AJBaseWebLoader : AJViewController

#pragma mark --- 暴露属性

/// webView
@property (nonatomic, weak) WKWebView *wv;

/// 传递参数的字典
@property (nonatomic, strong) NSDictionary *parameter;


#pragma mark --- AJJSPageApi

/// 重新加载WKWebview
- (void)reloadWKWebview;

#pragma mark --- AJJSAuthApi

/// 通过容器中持有的bridge属性注册API的方法
- (BOOL)registerHandlersWithClassName:(NSString *)className moduleName:(NSString *)moduleName;


@end

NS_ASSUME_NONNULL_END
