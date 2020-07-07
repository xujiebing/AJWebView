//
//  AJWebViewJSBridgeBase.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import "AJWebViewJSBridgeBase.h"

@implementation AJWebViewJSBridgeBase {
    __weak id _webViewDelegate;
    long _uniqueId;
}

static bool logging = false;
static int logMaxLength = 500;

+ (void)enableLogging {
    logging = true;
}

+ (void)setLogMaxLength:(int)length {
    logMaxLength = length;
}

-(id)init {
    if (self = [super init]) {
        self.responseCallbacks = [NSMutableDictionary dictionary];
        _uniqueId = 0;
    }
    return self;
}

- (void)dealloc {
    self.responseCallbacks = nil;    
    NSLog(@"<AJWebViewJSBridgeBase>dealloc");
}

- (void)reset {
    self.responseCallbacks = [NSMutableDictionary dictionary];
    _uniqueId = 0;
}

- (void)sendData:(id)data responseCallback:(WVJBResponseCallback)responseCallback handlerName:(NSString*)handlerName {
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    if (data) {
        message[@"data"] = data;
    }
    
    if (responseCallback) {
        NSString* callbackId = [NSString stringWithFormat:@"objc_cb_%ld", ++_uniqueId];
        self.responseCallbacks[callbackId] = [responseCallback copy];
        message[@"callbackId"] = callbackId;
    }
    
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _queueMessage:message];
}

// Private
// -------------------------------------------

- (void) _evaluateJavascript:(NSString *)javascriptCommand {
    if (![self.delegate respondsToSelector:@selector(evaluateJavascript:)]) {
        return;
    }
    [self.delegate evaluateJavascript:javascriptCommand];
}

- (void)_queueMessage:(WVJBMessage *)message {
    [self _dispatchMessage:message];
}

- (void)_dispatchMessage:(WVJBMessage *)message {
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    [self _log:@"SEND" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"JSBridge._handleMessageFromNative('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self _evaluateJavascript:javascriptCommand];

    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self _evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray*)_deserializeMessageJSON:(NSString *)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

- (void)_log:(NSString *)action json:(id)json {
    if (!logging) {
        return;
    }
    if (![json isKindOfClass:[NSString class]]) {
        json = [self _serializeMessage:json pretty:YES];
    }
    if ([json length] > logMaxLength) {
        NSLog(@"WVJB %@: %@ [...]", action, [json substringToIndex:logMaxLength]);
    } else {
        NSLog(@"WVJB %@: %@", action, json);
    }
}

#pragma mark --- BWTJS

- (NSArray *)deserializeMessageJSON:(NSString *)messageJSON {
    return [self _deserializeMessageJSON:messageJSON];
}

- (void)excuteMsg:(NSDictionary *)msgDic {
    __weak typeof(self) weakSelf = self;
    // 输出内容
    NSLog(@"RCVC:%@", msgDic);
    
    NSString *moduleName = msgDic[@"moduleName"];
    NSString *callbackId = msgDic[@"callbackId"];
    
    //判断模块是否存在
    AJRegisterBaseClass *bs = [self.modulesDic ajObjectForKey:moduleName];
    if (moduleName) {
        if (bs == nil) {
            //模块未注册
            NSLog(@"调用模块未注册");
            if (callbackId) {
                [self callbackWithId:callbackId code:@0 msg:@"调用模块未注册"];
            } else {
                NSLog(@"调用模块未注册，并且回调不存在");
            }
            return;
        }
    } else {
        NSLog(@"JS未传moduleName参数");
    }
    
    WVJBResponseCallback responseCallback = NULL;
    if (callbackId) {
        responseCallback = ^(id responseData) {
            if (responseData == nil) {
                responseData = [NSNull null];
            }
            WVJBMessage *msg = @{@"responseId":callbackId, @"responseData":responseData};
            [weakSelf _queueMessage:msg];
        };
    } else {
        responseCallback = ^(id ignoreResponseData) {
            // Do nothing
        };
    }
    NSString *handlerName = msgDic[@"handlerName"];
    if (!handlerName) {
        if (callbackId) {
            [self callbackWithId:callbackId code:@0 msg:@"API名字参数未传"];
        } else {
            NSLog(@"API名字参数未传，并且回调不存在");
        }
        return;
    }
    WVJBHandler handler = [bs handler:handlerName];
    if (!handler) {
        if (callbackId) {
            [self callbackWithId:callbackId code:@0 msg:@"API未注册"];
        } else {
            NSLog(@"API未注册，并且回调不存在");
        }
        return;
    }
    
    handler(msgDic[@"data"], responseCallback);
    return;
}

- (void)callbackWithId:(NSString *)callbackId code:(id)code msg:(NSString *)msg {
    if (callbackId) {
        NSMutableDictionary *responseData = [NSMutableDictionary dictionary];
        if (code) {
            [responseData setObject:code forKey:@"code"];
        }
        
        if (msg) {
            [responseData setObject:msg forKey:@"msg"];
        }
        
        WVJBMessage *errorMsg = @{ @"responseId":callbackId, @"responseData":responseData };
        [self _queueMessage:errorMsg];
    }
}

- (NSMutableDictionary *)modulesDic {
    if (_modulesDic == nil) {
        _modulesDic = [NSMutableDictionary dictionary];
    }
    return _modulesDic;
}


@end
