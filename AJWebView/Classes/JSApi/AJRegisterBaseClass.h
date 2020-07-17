//
//  AJRegisterBaseClass.h
//  AJKit
//
//  Created by 徐结兵 on 2020/7/4.
//

#import <Foundation/Foundation.h>
@class AJBaseWebLoader;

NS_ASSUME_NONNULL_BEGIN

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^WVJBHandler)(id data, WVJBResponseCallback responseCallback);

@interface AJRegisterBaseClass : NSObject

/// 所有API的字典
@property (nonatomic, strong) NSMutableDictionary *handlesDic;

/// 模块名
@property (nonatomic, strong) NSString *moduleName;

/// webView容器
@property (nonatomic, weak) AJBaseWebLoader *webloader;

/// 子类使用该方法注册
- (void)registerHandlers;

/// 保存API到字典中
/// @param handlerName API中的方法名
/// @param handler 获取的页面上的回调
- (void)registerHandlerName:(NSString *)handlerName handler:(WVJBHandler)handler;

/// 根据API名称获取保存的API回调
/// @param handlerName API中的方法名
- (WVJBHandler)handler:(NSString *)handlerName;

/// 统一回调参数字典拼装
/// @param code 1、0
/// @param msg msg
/// @param data result
- (NSDictionary *)responseDicWithCode:(NSInteger)code
                                  Msg:(NSString *)msg
                               result:(id _Nullable)data;

#pragma mark --- cacheHandlerDic相关方法

/// 保存方法
- (void)saveObjectInCacheDic:(id)value
                      forKey:(NSString *)keyName;

/// 获取方法
- (id)objectForKeyInCacheDic:(NSString *)keyName;

/// 删除方法
- (void)removeObjectForKeyInCacheDic:(NSString *)keyName;

/// 是否包含指定的value值
/// @param keyName key
- (BOOL)containObjectForKeyInCacheDic:(NSString *)keyName;

/// 释放内存
- (void)releaseRAM;

@end

NS_ASSUME_NONNULL_END
