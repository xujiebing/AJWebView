//
//  AJWebViewJSBridgeBase.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kCustomProtocolScheme @"AJJSBridge"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);
typedef NSDictionary WVJBMessage;

@protocol AJWebViewJSBridgeBaseDelegate <NSObject>

- (NSString*)evaluateJavascript:(NSString *)javascriptCommand;

@end

@interface AJWebViewJSBridgeBase : NSObject

@property (weak, nonatomic) id <AJWebViewJSBridgeBaseDelegate>delegate;

/// 新增，存放各个api module的实例
@property (nonatomic, strong) NSMutableDictionary *modulesDic;

+ (void)enableLogging;

- (void)sendData:(id)data handlerName:(NSString*)handlerName;

- (void)excuteMsg:(NSDictionary *)msgDic;

- (NSArray *)deserializeMessageJSON:(NSString *)messageJSON;

@end

NS_ASSUME_NONNULL_END
