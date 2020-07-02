#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BWTBaseWebLoader.h"
#import "BWTHybridWebview.h"
#import "BWTRegisterBaseClass.h"
#import "BWTBaseWebCacheProtocol.h"
#import "BWTBaseWebCacheTools.h"
#import "NSURLProtocol+BWTBaseWeb.h"
#import "WebViewJavascriptBridgeBase.h"
#import "WKWebViewJavascriptBridge.h"

FOUNDATION_EXPORT double AJWebViewVersionNumber;
FOUNDATION_EXPORT const unsigned char AJWebViewVersionString[];

