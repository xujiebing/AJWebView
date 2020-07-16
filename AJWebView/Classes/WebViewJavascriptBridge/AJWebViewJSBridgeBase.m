//
//  AJWebViewJSBridgeBase.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJWebViewJSBridgeBase.h"

static bool logging = false;

@interface AJWebViewJSBridgeBase ()

@end

@implementation AJWebViewJSBridgeBase

#pragma mark === 公共方法

+ (void)enableLogging {
    logging = true;
}

- (void)sendData:(id)data handlerName:(NSString*)handlerName {
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self p_dispatchMessage:message];
}

- (void)excuteMsg:(NSDictionary *)msgDic {
    AJLog(@"RCVC:%@", msgDic);
    if (NSDictionary.ajIsEmpty(msgDic)) {
        return;
    }
    NSString *moduleName = [msgDic ajObjectForKey:@"moduleName"];
    if (NSString.ajIsEmpty(moduleName)) {
        AJLog(@"JS未传moduleName参数");
        return;
    }
    NSString *callbackId = [msgDic ajObjectForKey:@"callbackId"];
    AJRegisterBaseClass *bs = [self.modulesDic ajObjectForKey:moduleName];
    if (!bs) {
        // 模块未注册
        if (NSString.ajIsEmpty(callbackId)) {
            AJLog(@"调用模块未注册，并且回调不存在");
            return;
        }
        AJLog(@"调用模块未注册");
        NSDictionary *responseData = @{@"code":@0, @"msg":@"调用模块未注册"};
        WVJBMessage *errorMsg = @{ @"responseId":callbackId, @"responseData":responseData };
        [self p_dispatchMessage:errorMsg];
        return;
    }
    
    NSString *handlerName = [msgDic ajObjectForKey:@"handlerName"];
    if (NSString.ajIsEmpty(handlerName)) {
        if (NSString.ajIsEmpty(callbackId)) {
            AJLog(@"API名字参数未传，并且回调不存在");
            return;
        }
        NSDictionary *responseData = @{@"code":@0, @"msg":@"API名字参数未传"};
        WVJBMessage *errorMsg = @{ @"responseId":callbackId, @"responseData":responseData };
        [self p_dispatchMessage:errorMsg];
        return;
    }
    WVJBHandler handler = [bs handler:handlerName];
    if (!handler) {
        if (NSString.ajIsEmpty(callbackId)) {
            AJLog(@"API未注册，并且回调不存在");
            return;
        }
        NSDictionary *responseData = @{@"code":@0, @"msg":@"API未注册"};
        WVJBMessage *errorMsg = @{ @"responseId":callbackId, @"responseData":responseData };
        [self p_dispatchMessage:errorMsg];
        return;
    }
    
    kAJWeakSelf
    WVJBResponseCallback responseCallback = NULL;
    if (NSString.ajIsEmpty(callbackId)) {
        responseCallback = ^(id ignoreResponseData) {
            // Do nothing
        };
    } else {
        responseCallback = ^(id responseData) {
            if (!responseData) {
                responseData = [NSNull null];
            }
            WVJBMessage *msg = @{@"responseId":callbackId, @"responseData":responseData};
            [ajSelf p_dispatchMessage:msg];
        };
    }
    handler([msgDic ajObjectForKey:@"data"], responseCallback);
}

- (NSArray *)deserializeMessageJSON:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)dealloc {
    AJLog(@"<AJWebViewJSBridgeBase>dealloc");
}

#pragma mark === 私有方法

- (void)p_evaluateJavascript:(NSString *)javascriptCommand {
    if (![self.delegate respondsToSelector:@selector(evaluateJavascript:)]) {
        return;
    }
    [self.delegate evaluateJavascript:javascriptCommand];
}

- (void)p_dispatchMessage:(WVJBMessage *)message {
    NSString *messageJSON = [self p_serializeMessage:message pretty:NO];
    [self p_log:@"SEND" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString *javascriptCommand = [NSString stringWithFormat:@"JSBridge._handleMessageFromNative('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self p_evaluateJavascript:javascriptCommand];

    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self p_evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)p_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (void)p_log:(NSString *)action json:(id)json {
    if (!logging) {
        return;
    }
    if (![json isKindOfClass:[NSString class]]) {
        json = [self p_serializeMessage:json pretty:YES];
    }
    AJLog(@"WVJB %@: %@", action, json);
}

#pragma mark === getter方法

- (NSMutableDictionary *)modulesDic {
    if (!_modulesDic) {
        _modulesDic = [NSMutableDictionary dictionary];
    }
    return _modulesDic;
}

@end
