//
//  AJRegisterBaseClass.m
//  AJKit
//
//  Created by 徐结兵 on 2020/7/4.
//

#import "AJRegisterBaseClass.h"

@interface AJRegisterBaseClass ()

/**
 开放给系统API的内部操作使用的字典，可临时在本页面中缓存多种数据
 */
@property (nonatomic, strong) NSMutableDictionary *cacheHandlerDic;

@end

@implementation AJRegisterBaseClass

- (NSMutableDictionary *)handlesDic {
    if (!_handlesDic) {
        _handlesDic = [NSMutableDictionary dictionary];
    }
    return _handlesDic;
}

- (NSMutableDictionary *)cacheHandlerDic {
    if (!_cacheHandlerDic) {
        _cacheHandlerDic = [NSMutableDictionary dictionary];
    }
    return _cacheHandlerDic;
}

//子类使用该方法注册
- (void)registerHandlers {
    
}

#pragma mark --- API回调的存取方法

//保存API到字典中
- (void)registerHandlerName:(NSString *)handleName handler:(WVJBHandler)handler {
    [self.handlesDic setObject:handler forKey:handleName];
}

//根据API名称获取保存的API回调
- (WVJBHandler)handler:(NSString *)handlerName {
    return [self.handlesDic objectForKey:handlerName];
}

//统一回调参数字典拼装
- (NSDictionary *)responseDicWithCode:(NSInteger)code
                                  Msg:(NSString *)msg
                               result:(id)data {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(code) forKey:@"code"];
    
    if (msg == nil) {
        msg = @"";
    }
    [dic setObject:msg forKey:@"msg"];
    
    if (data) {
        [dic setObject:data forKey:@"result"];
    }
    return dic;
}

#pragma mark --- cacheHandlerDic的相关方法

//保存
- (void)saveObjectInCacheDic:(id)value forKey:(NSString *)keyName; {
    if (value && (keyName.length > 0)) {
        [self.cacheHandlerDic setObject:value forKey:keyName];
    }
}

//获取
- (id)objectForKeyInCacheDic:(NSString *)keyName {
    if ([self.cacheHandlerDic ajContainsObjectForKey:keyName]) {
        return [self.cacheHandlerDic ajObjectForKey:keyName];
    }
    return nil;
}

//删除
- (void)removeObjectForKeyInCacheDic:(NSString *)keyName {
    [self.cacheHandlerDic removeObjectForKey:keyName];
}

- (BOOL)containObjectForKeyInCacheDic:(NSString *)keyName {
    if (NSString.ajIsEmpty(keyName)) {
        return NO;
    }
    if ([self.cacheHandlerDic ajContainsObjectForKey:keyName]) {
        return YES;
    }
    return NO;
}

//释放内存的方法
- (void)releaseRAM {
    self.handlesDic = nil;
    self.cacheHandlerDic = nil;
}

@end
