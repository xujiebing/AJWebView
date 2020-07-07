//
//  AJWebViewJSBridge.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJWebViewJSBridge.h"

#if defined(supportsWKWebKit)

@interface AJWebViewJSBridge ()

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) AJWebViewJSBridgeBase *base;
@end

@implementation AJWebViewJSBridge {
    long _uniqueId;
}

#pragma mark === 生命周期方法

- (void)dealloc {
    //手动释放内存
    for (AJRegisterBaseClass *bsRegister in self.base.modulesDic.allValues) {
        [bsRegister releaseRAM];
    }
    _base = nil;
    _webView = nil;
    _webViewDelegate = nil;
    _webView.navigationDelegate = nil;
    
    NSLog(@"<AJWebViewJSBridge>dealloc");
}

#pragma mark === 公共方法

+ (instancetype)bridgeForWebView:(WKWebView*)webView {
    AJWebViewJSBridge *bridge = [[self alloc] init];
    bridge.webView = webView
    [bridge reset];
    return bridge;
}

+ (void)enableLogging {
    [AJWebViewJSBridgeBase enableLogging];
}

- (void)reset {
    [self.base reset];
}

//注册框架已有的API
- (void)registerFrameAPI {
    /// TODO:待开发
    [self registerHandlersWithClassName:@"BWTJSNavigatorApi" moduleName:@"navigator"];
    [self registerHandlersWithClassName:@"BWTJSRuntimeApi" moduleName:@"runtime"];
    [self registerHandlersWithClassName:@"BWTJSDeviceApi" moduleName:@"device"];
    [self registerHandlersWithClassName:@"BWTJSUserApi" moduleName:@"user"];
    [self registerHandlersWithClassName:@"BWTJSUIApi" moduleName:@"ui"];
    [self registerHandlersWithClassName:@"BWTJSPageApi" moduleName:@"page"];
    [self registerHandlersWithClassName:@"BWTJSUtilApi" moduleName:@"util"];
    [self registerHandlersWithClassName:@"BWTJSAuthApi" moduleName:@"auth"];
}

- (BOOL)registerHandlersWithClassName:(NSString *)className moduleName:(NSString *)moduleName {
    BOOL registerSuccess = YES;
    if ([className length] && [moduleName length]) {
        AJRegisterBaseClass *bsRegister = [[NSClassFromString(className) alloc] init];
        if (bsRegister && [bsRegister respondsToSelector:@selector(registerHandlers)]) {
            bsRegister.moduleName = moduleName;
            bsRegister.webloader = (AJBaseWebLoader *)_webViewDelegate;
            [bsRegister registerHandlers];
            [self.base.modulesDic setObject:bsRegister forKey:moduleName];
        } else {
            registerSuccess = NO;
            AJLog(@"Api模块注册失败, ClassName:%@, moduleName:%@", className, moduleName);
        }
    } else {
        registerSuccess = NO;
    }
    return registerSuccess;
}

//获取页面内临时缓存的数据或方法
- (id)objectForKeyInCacheDicWithModuleName:(NSString *)moduleName KeyName:(NSString *)keyName {
    if ([self.base.modulesDic.allKeys containsObject:moduleName]) {
        AJRegisterBaseClass *bs = [self.base.modulesDic objectForKey:moduleName];
        id object = [bs objectForKeyInCacheDic:keyName];
        if (object) {
            return object;
        }
    }
    return nil;
}

- (BOOL)containObjectForKeyInCacheDicWithModuleName:(NSString *)moduleName KeyName:(NSString *)keyName {
    if ([self.base.modulesDic.allKeys containsObject:moduleName]) {
        AJRegisterBaseClass *bs = [self.base.modulesDic objectForKey:moduleName];
        if ([bs containObjectForKeyInCacheDic:keyName]) {
            return YES;
        }
    }
    return NO;
}

//删除页面内临时缓存的数据或方法
- (void)removeObjectForKeyInCacheDicWithModuleName:(NSString *)moduleName KeyName:(NSString *)keyName {
    AJRegisterBaseClass *bs = [self.base.modulesDic objectForKey:moduleName];
    [bs removeObjectForKeyInCacheDic:keyName];
}

#pragma mark === getter方法

- (AJWebViewJSBridgeBase *)base {
    if (!_base) {
        _base = [[AJWebViewJSBridgeBase alloc] init];
        _base.delegate = self;
    }
    return _base;
}

#pragma mark === AJWebViewJSBridgeBaseDelegate

- (NSString *)evaluateJavascript:(NSString *)javascriptCommand {
    [self.webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    return NULL;
}

#pragma mark === 私有方法

#pragma mark === WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AJWebViewJSBridge"]) {
        [self excuteMessage:message.body];
    }
}

- (void)excuteMessage:(NSString *)message {
//    NSString *msgUTF8 = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *msgUTF8 = [message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *msgURL = [NSURL URLWithString:message];
    if (!msgURL) {
        return;
    }
    if (![msgURL.scheme isEqualToString:kCustomProtocolScheme]) {
        return;
    }
    // 解析参数
    NSString *moduleName = msgURL.host;
    NSString *handlerName = msgURL.path.lastPathComponent;
    NSString *callbackId = msgURL.port.stringValue;
    NSString *dataStr = [msgURL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *data = [msgURL.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    id dataObj = [self.base deserializeMessageJSON:data];
    
    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
    if (handlerName) {
        [msgDic setObject:handlerName forKey:@"handlerName"];
    }
    if (callbackId) {
        [msgDic setObject:callbackId forKey:@"callbackId"];
    }
    if (dataObj) {
        [msgDic setObject:dataObj forKey:@"data"];
    }
    if (moduleName) {
        [msgDic setObject:moduleName forKey:@"moduleName"];
    }
    [self.base excuteMsg:msgDic];
}

// URI解码
- (NSString *)URLDecodedString:(NSString*)stringURL {
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)stringURL, CFSTR(""), kCFStringEncodingUTF8);
}

- (void)handleErrorWithCode:(NSInteger)errorCode errorUrl:(NSString *)errorUrl errorDescription:(NSString *)errorDescription {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@(errorCode) forKey:@"errorCode"];
    if (errorUrl) {
        [paramDic setObject:errorUrl forKey:@"errorUrl"];
    }
    if (errorDescription) {
        [paramDic setObject:errorDescription forKey:@"errorDescription"];
    }
    [self.base sendData:paramDic responseCallback:nil handlerName:@"handleError"];
}

@end
#endif
